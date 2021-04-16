Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6ED3628F6
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhDPT4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243008AbhDPT4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:56:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1277C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:56:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v6so42498220ejo.6
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PODjp6xiM9HSv+lSlR8OW7aOuiPs4Di8F0vSROODgwE=;
        b=jX594VyP3hI9Aa7aENvCU5ovec0403QGE8hV7KFqy2z9Q5ESzM7pVPFLrpfXniZV6R
         3NHkujWf/acBrxNUjE0JQc+S9B9S+VCfANLiCH1JrG1g1VsbKyAILzO+XVTq616kYzqS
         gGqxLog3ST2SJXbsbaiOZuco6YZmbYs3xvLZSktkmnkqUt4vcJcoeIhgAaNeWHnqyT1U
         lgqNbXO5fFYqd4Tmp284Tk081IWG34vYibzh08iG0VszF2oNAggcViI+XV3zQFD1lPm5
         z9nmGtx3w0LvYMVycpBNOjQtA9wxT3AF2dPwLGuvDBtk6eo8Rf7doN0n6fmahKjS3S4I
         lf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=PODjp6xiM9HSv+lSlR8OW7aOuiPs4Di8F0vSROODgwE=;
        b=WpwLVDeqFjzh4/lXMQqe1Bn5aaFFc/H0LNpBd9I913wTD/ViEiV4dxcURnlgGJiZBE
         lNYjq8A/PTKMt4jCGh4wZEQy2YMYkvlwR/tak/QxvCcwOJVDj4cByeLYPGmJHXiJPkum
         74D+SEDf4SGOAVxTfPQqTsLGXiaDXE9AYBhJ3D/YaHGoh73vnhxRRKOOJonNTZz/nCL/
         AGhZI6Mmkixh45g1QO12eAhen1KgRf71pssjTCDlzTp8p3TNyeb74Flo/v2d9alIGRPv
         f/pB3SJtjVLwIi82mp31FEmsJHxM/Cnl1Wx5XEMyGZ1yXd9ITsbUEwjJnOhp+PYpgeOa
         A40Q==
X-Gm-Message-State: AOAM530XXi+EHtfKvB5NMe4HEpOf4+GmFKM0lwjG9xeSl107K9V5DBcJ
        8UWiCOH3HQ1zNos5MTYjSHo=
X-Google-Smtp-Source: ABdhPJwm0dGp96kneJp3Rhiqp6THw8hpN/FbbmL7holni1Q4pw3Yqx9LE+xctK5xs4jWl4c2j/HQKA==
X-Received: by 2002:a17:906:7795:: with SMTP id s21mr9812754ejm.309.1618602970329;
        Fri, 16 Apr 2021 12:56:10 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id i10sm6315026edt.3.2021.04.16.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:56:09 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Fri, 16 Apr 2021 21:56:08 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Steve Beattie <steve.beattie@canonical.com>
Subject: Please apply commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap()
 call into vfs_setxattr()") to stable series from 5.10.y back to 4.19.y
Message-ID: <YHnr2D9UO+pQO6uq@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha

Please consider to apply commit 7c03e2cda4a5 ("vfs: move
cap_convert_nscap() call into vfs_setxattr()") to stable series at
least back to 4.19.y. It applies to there (but have not tested older
series) and could test a build on top of 5.10.y with the commit.

The commit was applied in 5.11-rc1 and from the commit message:

    vfs: move cap_convert_nscap() call into vfs_setxattr()

    cap_convert_nscap() does permission checking as well as conversion of the
    xattr value conditionally based on fs's user-ns.

    This is needed by overlayfs and probably other layered fs (ecryptfs) and is
    what vfs_foo() is supposed to do anyway.

Additionally, in fact additionally for distribtuions kernels which do
allow unprivileged overlayfs mounts this as as well broader
consequences, as explained in
https://www.openwall.com/lists/oss-security/2021/04/16/1 .

Thanks for considering!

Regards,
Salvatore
