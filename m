Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B0E5181
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 18:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbfJYQpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 12:45:22 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:38085 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633105AbfJYQoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 12:44:24 -0400
Received: by mail-io1-f54.google.com with SMTP id u8so3152793iom.5
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FnNCWhzA8wzAQcW3IvtMxmOw0mIYmbzhbuz8jcog3z0=;
        b=FE/GwmYd89R7oOACf+gouF5/sDJA7KfixcIXlgu0Zy2xBlflmjGhsPtumrOF2/chO7
         ukgC7RpX2WU0ieTsoaIEsugTNO9IxVY55sHdmI8YDpkuFlrYNj3TJ3Yyh4TkMX3TEZVP
         euzKnHoQXH1CnnfPJ8ycKy7wwlV1V2ytUcp0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FnNCWhzA8wzAQcW3IvtMxmOw0mIYmbzhbuz8jcog3z0=;
        b=MHQOQ2Rv/DnIR6sVxx4lUlWaPedF2lK/FOmB6U3xSfmX4x2VXFeBlDZSy+w79X94ZD
         X3M/hC4AWXXRP1j9vNMcHDV8oTuYerfslvis78LrGrgjt9IbrX/vC7hYKAHG0vm8Irz1
         Lwg2lFqAn/pPEEB7z/jxNKzNE+Av4CCO/aVNwTXdvLWJSlbMXskcU17OnjQiEPkhUVUK
         MWrK/aHfhpb9Jcp1tiFsekjdmBY5iQW8vlP4J4UBRDrMr0aNxeKX5NFcpgHCJ3aikbqZ
         dGyYoxvWobrCbQdcGTlUJ+VqX42HZQz7N5bW8IAWQN1iFAAQuoUoAlMKGYZd4IwtqGqr
         Telg==
X-Gm-Message-State: APjAAAX5SFFZ6WxkCLBcQSoyzentuzoB9dicfvZJVM6y822hTLME1xAO
        OePGP+rXE9+M8FoYFQIKJy3227r+LUQ=
X-Google-Smtp-Source: APXvYqwGdsE5aUbh7b1e/6uOXowlc/IkNj2RVTViqEg5vn2SwFFtdFQeHWxA35W9FKSkT2wBQRNaww==
X-Received: by 2002:a05:6638:632:: with SMTP id h18mr4816228jar.55.1572021862317;
        Fri, 25 Oct 2019 09:44:22 -0700 (PDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com. [209.85.166.173])
        by smtp.gmail.com with ESMTPSA id k2sm328453ios.19.2019.10.25.09.44.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 09:44:21 -0700 (PDT)
Received: by mail-il1-f173.google.com with SMTP id m16so2374748iln.13
        for <stable@vger.kernel.org>; Fri, 25 Oct 2019 09:44:20 -0700 (PDT)
X-Received: by 2002:a92:d101:: with SMTP id a1mr5273789ilb.142.1572021860411;
 Fri, 25 Oct 2019 09:44:20 -0700 (PDT)
MIME-Version: 1.0
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 25 Oct 2019 09:44:09 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Uui+a6TS85VNv3XVApq7xYifd8m_ZTmShTC2jeGEO4jg@mail.gmail.com>
Message-ID: <CAD=FV=Uui+a6TS85VNv3XVApq7xYifd8m_ZTmShTC2jeGEO4jg@mail.gmail.com>
Subject: Please pick ("LSM: SafeSetID: Stop releasing uninitialized ruleset")
 to 5.3 stable
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     Guenter Roeck <groeck@chromium.org>,
        Micah Morton <mortonm@chromium.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If you're still taking things for 5.3 stable, I humbly request picking
up commit 21ab8580b383 ("LSM: SafeSetID: Stop releasing uninitialized
ruleset").  While bisecting other problems this crash tripped me up
and I would have been able to bisect faster had the fix been in
linux-stable.  Only kernel 5.3 is affected.

For reference, the crash for me looked like:

Call trace:
 __call_rcu+0x2c/0x1ac
 call_rcu+0x28/0x34
 safesetid_file_write+0x344/0x350
 __vfs_write+0x54/0x18c
 vfs_write+0xcc/0x18c
 ksys_write+0x7c/0xe4
 __arm64_sys_write+0x20/0x2c
 el0_svc_common+0x9c/0x14c
 el0_svc_compat_handler+0x28/0x34
 el0_svc_compat+0x8/0x10

Thanks much.

-Doug
