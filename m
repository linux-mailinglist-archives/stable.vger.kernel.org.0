Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8D34342C9
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 03:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhJTBWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 21:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhJTBWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 21:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4738461004;
        Wed, 20 Oct 2021 01:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634692823;
        bh=Y9YTnWytaS21lTU5HjMbOEAOxoi3tAKPASr/Yz5hlyE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cKH1whHvr7tgZakDvhKAKA41L+oODyZFRLblC3C29G8qcZ47DNk2SZkJNNkRaUVJs
         538423OqHTyEmHWMpD2hIb0PojtN0E40eXu+nVx8AWAxDot0RmVOepnP4FU+f3k2LP
         djX/zTFjL7jAuQ9NtHiT7XKhwYlGr4EumK8lPKHJCp1s/BH1RbmaJpUl3BzohUHEyN
         UP7u6aYERV5YLaTja2yK9ETYKFsDjstWSHshfTpQhOUlaEEc4vv83i/bxSBtKG0Soh
         RHQ000yYH4VbUZFJrK/PR8Riiq22aww/Z/JFTW5S6fxT1IG20g1T0QgdkL1YYx3l/w
         4QqbBDKHOfZHA==
Received: by mail-oi1-f174.google.com with SMTP id o4so7615811oia.10;
        Tue, 19 Oct 2021 18:20:23 -0700 (PDT)
X-Gm-Message-State: AOAM530W/qkV7YuAS+xtUMH+irWpSHu6lUhxxOgFUJQFQkIBUaqtyj/R
        VNI/LoyXv3vGV8R7dqP2p1ZtvFigdNMGqa/ig28=
X-Google-Smtp-Source: ABdhPJyc7uZZtJc5h2DcrZsV0OsIflnkcE9RvRdcpZgwCxw9+pdMkxKPCiEvbdUSHlktwo2zijevr7XZJUTvGQKFYc8=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr7237239oif.51.1634692822587;
 Tue, 19 Oct 2021 18:20:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 19 Oct 2021 18:20:22
 -0700 (PDT)
In-Reply-To: <20211019061421.23706-1-sj1557.seo@samsung.com>
References: <CGME20211019061448epcas1p1c6951207ef0ba73f1ef17862bb4495ff@epcas1p1.samsung.com>
 <20211019061421.23706-1-sj1557.seo@samsung.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 20 Oct 2021 10:20:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-s39+YnX1xR=KdLH+JnZ=tAa5M19=Ra-CWUWWKzuTgOw@mail.gmail.com>
Message-ID: <CAKYAXd-s39+YnX1xR=KdLH+JnZ=tAa5M19=Ra-CWUWWKzuTgOw@mail.gmail.com>
Subject: Re: [PATCH v2] exfat: fix incorrect loading of i_blocks for large files
To:     Sungjong Seo <sj1557.seo@samsung.com>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2021-10-19 15:14 GMT+09:00, Sungjong Seo <sj1557.seo@samsung.com>:
> When calculating i_blocks, there was a mistake that was masked with a
> 32-bit variable. So i_blocks for files larger than 4 GiB had incorrect
> values. Mask with a 64-bit variable instead of 32-bit one.
>
> Fixes: 5f2aa075070c ("exfat: add inode operations")
> Cc: stable@vger.kernel.org # v5.7+
> Reported-by: Ganapathi Kamath <hgkamath@hotmail.com>
> Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Applied, Thanks for your patch!
