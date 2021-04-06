Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDED4355274
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbhDFLif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 07:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbhDFLif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 07:38:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60482C06174A;
        Tue,  6 Apr 2021 04:38:27 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id n2so15122905ejy.7;
        Tue, 06 Apr 2021 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iTEUgiIQVz1rqjlpydUZiBeTPGXMaZVSh39Lp2/IRQw=;
        b=m67oh6sipyb9fxohn9HQYAAaiouSsyL5bRHgiMsVyM/Yn5PS5wUgaMUr+pPOqI7/1T
         Z8jXJYeJ5RMM4xE7oW1eplFmWeLBlhCoyoZmbtWser2DxKfW1kQOGaSIjkr8Oebf2uzT
         L6TpaWGHd6PWzPqAyF7SZMIxRJrNrVawvk9Lnd9cyPDhR+LZE0acI4H91uINE9y6w0Qk
         DV6CYmvgzfjqqH6VNvrG/ArUAo1jGwRhn5HGx10rTedCzyH36mWaTCPMAbo8USTV8vIQ
         51Bt7scVSHS2LtLftX5xVHP0NSTao9HYgd/8TM+Rr7ZyBIaNe2EsWinVP9IsHotawZvb
         u8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iTEUgiIQVz1rqjlpydUZiBeTPGXMaZVSh39Lp2/IRQw=;
        b=jguVmR90H+5GZ1xHW0BP9oYiMvgx6zMlZLeMb66G6hqu00u7/Iy0oSXYokKmyL//ft
         7K0LZVj+9kqQuaumHc0kMxvWkV1ZzLBmq2FhDmacXTpCpQmc41fL23ckm/Pgj1AkM7jd
         qECJ9OJFUDZL/bW62Aclh38joY/A34Jc9T04NV8gN3fs9rMkuMugtM5ULfzqe/nXfryr
         4YRIPQOMIY/9CxgvPouWixDkAMjsXtRvTHEdoXUAnHUGXNpvmlktjrEfxxLFIGDDP4CB
         3w/5lqiPXNpVb9gRqifJte5CowUO/jnfbdH79saREJM5OjByIKZQL2C4O460ZJNrzgkQ
         KTyw==
X-Gm-Message-State: AOAM531P99sHcdVGg+DRVHPEBaQIyMo5N4OHV7opziwvDpVCnKXQpHlu
        QqJtsVJJZooVYUeDFyNVglw=
X-Google-Smtp-Source: ABdhPJwV4lrVUb7PsDGuKZdCKTsCSNgo7l45l+K3bP4jeeYU3C21DOhpSrQtGT0pN2GlWQeQsEiBrg==
X-Received: by 2002:a17:906:ad4:: with SMTP id z20mr32776404ejf.496.1617709106193;
        Tue, 06 Apr 2021 04:38:26 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id e12sm4186390edv.11.2021.04.06.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 04:38:25 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 6 Apr 2021 13:38:24 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag
 on setting cifs_sb->prepath.
Message-ID: <YGxIMCsclG4E1/ck@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301161032.337414143@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Mar 01, 2021 at 05:10:33PM +0100, Greg Kroah-Hartman wrote:
> From: Shyam Prasad N <sprasad@microsoft.com>
> 
> [ Upstream commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b ]
> 
> While debugging another issue today, Steve and I noticed that if a
> subdir for a file share is already mounted on the client, any new
> mount of any other subdir (or the file share root) of the same share
> results in sharing the cifs superblock, which e.g. can result in
> incorrect device name.
> 
> While setting prefix path for the root of a cifs_sb,
> CIFS_MOUNT_USE_PREFIX_PATH flag should also be set.
> Without it, prepath is not even considered in some places,
> and output of "mount" and various /proc/<>/*mount* related
> options can be missing part of the device name.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/cifs/connect.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6285085195c15..632249ce61eba 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3882,6 +3882,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
>  		if (cifs_sb->prepath == NULL)
>  			return -ENOMEM;
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
>  	}
>  
>  	return 0;

A user in Debian reported an issue with mounts of DFS shares after an
update in Debian from 4.19.177 to 4.181:

https://lists.debian.org/debian-user/2021/04/msg00062.html

In a test setup i was able to reproduce the issue with 4.19.184 itself
(but interestingly not withing the 5.10.y series, checked 5.10.26)
which both contain the above commit.

4.19.184 with a738c93fb1c1 ("cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag
on setting cifs_sb->prepath.") reverted fixes the issue.

Is there probably some missing prerequisites missing in the 4.19.y
brach? I could not test othr versions, but maybe other versions are
affected as well as before 4.19.y, as the commit was backported to
4.14.223 as well.

Regards,
Salvatore
