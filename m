Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1077435822E
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 13:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhDHLlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 07:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhDHLlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 07:41:20 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC00BC061760;
        Thu,  8 Apr 2021 04:41:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id m3so2011510edv.5;
        Thu, 08 Apr 2021 04:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9W5u9JNowWa9GKxAEJ2E0StodFgzOY5U/p+9mBXj95I=;
        b=JS9eJVgfynJVA/3KbS/hCW7MZIRKZOZIb53vErZBMLiiUIDtvkF1fooyQqBpG/Nkha
         KDqgCL/4YxMOHY4MTNymEdVId38BxQKiBv+9mgVVOwdTua1aDF4OB+lwfCIYXz/74RSX
         IvcwsAmiN9MvOQ2G8IJn8//yx9tHkXRpfIBLRk9Qh8ONXrg7pMxB5LHfqjy8KX1W3RKW
         NxYTE4UbK4zYnK/rNUNvbIbItAkTqolE4KbtEO7FDHdne+Hg0ED8YZC0ja8qbIQ9ufdM
         FyXdrjraBx40JUUtVYMdxfSkd1LQOQ2C04485KMr/UUrOXpVamPb9JC2UT0Hz9OX3W/z
         Tm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9W5u9JNowWa9GKxAEJ2E0StodFgzOY5U/p+9mBXj95I=;
        b=qJkr4Mn04mBKgNYlHGtflnHpIF2D9eu5xHbM2tkWKu3UbWPmWBg2j36ZGfDWfDebr0
         NU7/AtfnQCX5hQz2Ooyw6xHz2ktxz9jsoVIHQDUV2ycIWZep0D+C4vUvCT1ob6me6Wyj
         gcBe4YXvs2lC5uAbK+yqCbu7GvriyHBlDOETIGr4w+l5gcHfPvcRmyo/g3OQDgvX7S/1
         yhAQuAZtdmATwmax4LIn42E1POFbrFnuNEwdwnRbArs7xNdNJVFqBRXiEEXq/L5UffpG
         oVq0iAAJTrm/GunHQjfODg1LpsPJ/Z9mWyYifdsE3IK03vPKpKj4MPdIhSOPwwbd7fv4
         A1/g==
X-Gm-Message-State: AOAM531/KwcTk5rbk+QH51fp07MQbWeplVJz+yTEXbFmyvKoe4kPQh7J
        cZ11ZFbViht1IEg+VHDs4V0=
X-Google-Smtp-Source: ABdhPJxHjMV9iH5aPR/Kq3Q/3Ykz/dCa08ogguDQJ1C7Z1FnpkfIOpxzgMQf5JbPNlDlihhMHL27mw==
X-Received: by 2002:a50:d84e:: with SMTP id v14mr11046764edj.357.1617882067518;
        Thu, 08 Apr 2021 04:41:07 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q25sm17449500edt.51.2021.04.08.04.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:41:06 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Thu, 8 Apr 2021 13:41:05 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YG7r0UaivWZL762N@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGx3u01Wa/DDnjlV@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shyam,

On Tue, Apr 06, 2021 at 05:01:17PM +0200, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Tue, Apr 06, 2021 at 02:00:48PM +0000, Shyam Prasad wrote:
> > Hi Greg,
> > We'll need to debug this further to understand what's going on. 
> 
> Greg asked it the same happens with 5.4 as well, I do not know I was
> not able to test 5.4.y (yet) but only 5.10.y and 4.19.y.
> > 
> > Hi Salvatore,
> > Any chance that you'll be able to provide us the cifsFYI logs from the time of mount failure?
> > https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
> 
> Please find it attached. Is this enough information?
> 
> The mentioned home DFS link 'home' is a DFS link to
> msdfs:SECONDHOST\REDACTED on a Samba host.
> 
> The mount is triggered as
> 
> mount -t cifs //HOSTIP/REDACTED/home /mnt --verbose -o username='REDACTED,domain=DOMAIN'

So I can confirm the issue is both present in 4.19.185 and 5.4.110
upstream (without any Debian patches applied, we do not anyway apply
any cifs related one on top of the respetive upstream version).

The issue is not present in 5.10.28.

So I think there are commits as dependency of a738c93fb1c1 ("cifs: Set
CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.") which
are required and not applied in the released before 5.10.y which make
introducing the regression.

Regards,
Salvatore
