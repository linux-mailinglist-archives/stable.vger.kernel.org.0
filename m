Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653542970C7
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372591AbgJWNka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 09:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372086AbgJWNka (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 09:40:30 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E102AC0613CE
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 06:40:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x1so1582562eds.1
        for <stable@vger.kernel.org>; Fri, 23 Oct 2020 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=C7scyvHlrOdlyJVggLq0/PPNcQWlw4W/p8da1eTopDY=;
        b=RgocgajM82za5/KcSbU0vSzR0plP00yvv+qeHEdE9D08aKamQ3C/DS7qi4PcyazLUW
         xiC5ioDemQnQTEBrZnc/gH544TlQSTas7AWheBDKvd+e3bk52yMsscmKaNnG98VV5gIf
         Q4T9cZQvs1Leb6Uo3oEOpTb2DNFYXaqIsgvsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=C7scyvHlrOdlyJVggLq0/PPNcQWlw4W/p8da1eTopDY=;
        b=ilch+XGb0E7d5VL5e5h4NGbX7cSPwLjd0u/zmGWcNi+3mb4kRsFRc58Qd0WEwaqP+w
         wOwHPMkW/T7T1Or3kfBTOijJrGUEpJ7pf2V0yAKHUrNPlAP0+7tD9nCPGNWavcBE3+x3
         xqlokZEv4vGbHbs7YNg5pXC5LbpesqvRmxGtbM4bzM8FMPKjIeVrYuJ/+tI4JKN3EV+K
         +3Sde5bOoXOnhWGj2v8O1ENng1Gd2dakALFzXUQcLK0IQUzoDzQnuqe4Ns3SPdP9IsAB
         6rt1lh8rXVSbJGABCZ0gXh8HNcpf5XsRymPytcEeOq0yXZ2uFqJ+RKPnnUI4fb/2wLgR
         frlg==
X-Gm-Message-State: AOAM532rey/ytTZ+zRqM3n++2fwBSdgq/wtFpSfJoEW6FcuQgJZiqsPw
        C8g+4XTRHs+dSv6LmBhCO608e0G6KwekLkaqjiw=
X-Google-Smtp-Source: ABdhPJw5mPb/L97FRG/46MYAkiw64/u44Bkizpd6Hhh4NsbjJCpRZ5kuYd/g1XjzEFbCJazT7VWVWg==
X-Received: by 2002:a50:aa84:: with SMTP id q4mr2226840edc.331.1603460428345;
        Fri, 23 Oct 2020 06:40:28 -0700 (PDT)
Received: from [172.16.11.132] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id q2sm863677ejd.20.2020.10.23.06.40.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 06:40:27 -0700 (PDT)
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: does 548b8b5168c9 qualify for stable?
Message-ID: <4f1324d2-6b0f-dcb6-ff58-a6a05a15d407@rasmusvillemoes.dk>
Date:   Fri, 23 Oct 2020 15:40:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider whether

commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8
Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date:   Thu Sep 17 08:56:11 2020 +0200

    scripts/setlocalversion: make git describe output more reliable

qualifies for -stable. It removes one potential source of binary
non-reproducibility that we have actually seen cause problems.

I'm fine with it not qualifying, but please let me know if so, because
then I'll go and add some workarounds to various customer projects.

In case it doesn't cherry-pick cleanly (I think there might have been
some shell-portability patches replacing $() by `` or something like
that) I am happy to provide backports to the still maintained -stable
branches.

Thanks,
Rasmus
