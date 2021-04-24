Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732D9369DD8
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 02:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhDXAcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 20:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbhDXAcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 20:32:45 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736C7C06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 17:32:07 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id z14-20020a0cf24e0000b02901ab51b95ae7so9181565qvl.10
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 17:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RFejzidZs9WShC54Po/eQzucWBdnznAwGFTqW1GHtRA=;
        b=m5Pzy1/XJ+loDk6eFxYjHiBLEWRQYL0J4X0ksUJl1NZbABjbPj5VDQS+kCVOxB6Ov5
         KF6kAt7LUZO2Oa7QDzOg/W2udelkzdNvyTneZmeVhXe6Sq02vgeyURI+guxG1Yow6wcC
         bIJskRi1Ua9X7jR/L2IrYbPZPvVa9U1MNknIttWKNfpbQK8fpDweUp9v5rDyaruQ23lG
         mCKVasoKPdjHyi20Msa8NY/P+9RTPQBLWQBMFy90k6rP/cLi5+y8dHNpvrIGGDs8gG7p
         3FQ+YLVIHJk8UyhE7QUuWviylIhyxc4CucNrU+IzHFOQVloCkAFs3NshmX08FrjJ3CYv
         LcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RFejzidZs9WShC54Po/eQzucWBdnznAwGFTqW1GHtRA=;
        b=NSKg772KqZfVfCFqgXWQ+Rt4GGOXlvnV4bLGmfWx2l7IFEpzgtEmGQBhUaD+A9kGbJ
         HtGDMsWOZuLhBbeYlFmdCW5eTAHTjCe0I5E+uKzBKVIZjCUkjJWdrm5ZGxMNVCdg66Me
         jCHQCb3PAdq1OiRzgyy1iru54VCA5XW6Eu9hF5K/12XY4dvsxX1oVK6wh55KBN39Zqaf
         kv/UgMpZDNKf0+EtAEqM7Y5N4g065y5+mfABrV1ix0I5XoN3kUrpzEjcKOJHWbRXttVY
         km891NBIzb24ybcSv6YdYFu4OqDjfqEZNT8NGXjLdxdp68hVbFhFxdL3d2u01ndiI44j
         QQdg==
X-Gm-Message-State: AOAM530OdH9u9ciNcgX7U64ZPrldn35kXM53t7NRSxQ1wrtmOxINuO8g
        hrXslJyO6GPuiy1I6RhSPXetyjz1eNZ6In8H
X-Google-Smtp-Source: ABdhPJxQMJnyA85XBhuZy+o/vPEW0Obv4Fc6bJsnFW7BBf5sWNUsHo6zFmCeTWWldeb6Nd2py7jKrhPWh/BcDPb0
X-Received: from manoj.svl.corp.google.com ([2620:15c:2ce:0:fca2:d161:2d88:e606])
 (user=manojgupta job=sendgmr) by 2002:a05:6214:1d0c:: with SMTP id
 e12mr7247304qvd.0.1619224326605; Fri, 23 Apr 2021 17:32:06 -0700 (PDT)
Date:   Fri, 23 Apr 2021 17:31:31 -0700
In-Reply-To: <20210422182545.726897-1-manojgupta@google.com>
Message-Id: <20210424003131.2165866-1-manojgupta@google.com>
Mime-Version: 1.0
References: <20210422182545.726897-1-manojgupta@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH] iw: set retain atrribute on sections
From:   Manoj Gupta <manojgupta@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     llozano@google.com, manojgupta@google.com,
        linux-wireless@vger.kernel.org, Fangrui Song <maskray@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLD 13 and GNU ld 2.37 support -z start-stop-gc which allows garbage
collection of C identifier name sections despite the __start_/__stop_
references.  Simply set the retain attribute so that GCC 11 (if
configure-time binutils is 2.36 or newer)/Clang 13 will set the
SHF_GNU_RETAIN section attribute to prevent garbage collection.

Without the patch, there are linker errors like the following with -z
start-stop-gc:
ld.lld: error: undefined symbol: __stop___cmd
>>> referenced by iw.c:418
>>>               iw.o:(__handle_cmd)

Suggested-by: Fangrui Song <maskray@google.com>

Cc: stable@vger.kernel.org

Signed-off-by: Manoj Gupta <manojgupta@google.com>
---
 iw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iw.h b/iw.h
index 7f7f4fc..67aa00c 100644
--- a/iw.h
+++ b/iw.h
@@ -118,8 +118,9 @@ struct chandef {
 		.parent = _section,					\
 		.selector = (_sel),					\
 	};								\
+	_Pragma("GCC diagnostic ignored \"-Wattributes\"") 		\
 	static struct cmd *__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden ## _p \
-	__attribute__((used,section("__cmd"))) =			\
+	__attribute__((used,retain,section("__cmd"))) =			\
 	&__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden
 #define __ACMD(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel, _alias)\
 	__COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel);\
-- 
2.31.1.498.g6c1eba8ee3d-goog

