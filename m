Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C3E462F23
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbhK3JDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhK3JDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:03:30 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBD0C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:00:11 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso18930056wms.2
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QJcffNGoqb18EByDkSlZ60OyOWrRCLmYC5gv2jGrn9s=;
        b=vYezTpUj+/qqTL+z3wswPOdfQ0aM0djLMLAsl7F3W+WWsItDk4J+OGNXg+pCErPi16
         exLvx+mxr0Eo4Tr/VlrQK4Pbkg8EoaUJEiUScRI98icgfN/k5XGQPv7L7Ks501cL3+uz
         scv7jz6+W5Pr6Jik/LfKN4/rdZTLXIzAMgty3u8VP/Xsm/YmDl433GreNIPo1GK9uoTA
         fYi8FVzO0GpmwUVmsDxOKeVLK/9ixADZjd9e/yt+vfGL3thOeViu5gk9pmvkTZpdw7uC
         Cr6gLRwVciiD5QEVnnkH8F8Ud2b60SZQCpGj3+GrV6fXOjmEdnr9WdkImL5e9cODOgOb
         O2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QJcffNGoqb18EByDkSlZ60OyOWrRCLmYC5gv2jGrn9s=;
        b=sWWPTffwdhWyaWxuh+v8ADzs5v604TgcCWH/IBcGalUn8zHSechVX+iIzam8BtRRYb
         AuTK7sBzvRz4FqOCT9+AKey2O0xo8ZGMMGHFXGiFvHPOH6Qt8QygLSjo43ame3Gpe2ZE
         0fdBOZL5OQP9Uy5Ir8x4mWzL4UPVpVyx23IGdrjQnXaVAtcKfd3a6l0HJvvhqoZoCnfO
         IuLSkO0DBQhXcl41EjNm7CoepQoVv7m7IwYjquhzwZi9xULxQVgCAeC7ACttJSXbPk+N
         RHvOAP0UCFhehJKhHbUf+MP+HROuwao3MGiYdLUP4OgU3Ckb+ADEAGt7e5UM7PV0ptY3
         L4vA==
X-Gm-Message-State: AOAM533jar1D35XqdvPGdg5a31ImB594C5roIpXe9ZBUY6Wx0zKIFF5q
        qZCJ8Qf0PlbUGSRfFOh6f46foElMeKgq3A==
X-Google-Smtp-Source: ABdhPJyJd0OFl2U35oZlz82GcW9Ut6QZy9yKKcLyNYR0T6zzRudq93FV0vmVHCqqA0gP8BUoR2Ibdw==
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr3442699wms.144.1638262809686;
        Tue, 30 Nov 2021 01:00:09 -0800 (PST)
Received: from ?IPV6:2003:d9:9706:4700:9438:3394:ac3b:1a31? (p200300d99706470094383394ac3b1a31.dip0.t-ipconnect.de. [2003:d9:9706:4700:9438:3394:ac3b:1a31])
        by smtp.googlemail.com with ESMTPSA id t8sm16285475wrv.30.2021.11.30.01.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 01:00:09 -0800 (PST)
Message-ID: <cb05fe18-f83c-7c84-eaca-3c3e69968b19@colorfullife.com>
Date:   Tue, 30 Nov 2021 10:00:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] ipc: WARN if trying to remove ipc object which is absent
Content-Language: en-US
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
References: <16375837111940@kroah.com>
 <20211129194811.827410-1-alexander.mikhalitsyn@virtuozzo.com>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20211129194811.827410-1-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 11/29/21 20:48, Alexander Mikhalitsyn wrote:
> For 4.14.y:
>
> Upstream commit 126e8bee943e ("ipc: WARN if trying to remove ipc object which is absent")
>
> Patch series "shm: shm_rmid_forced feature fixes".
[...]
> ---
>   ipc/util.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/ipc/util.c b/ipc/util.c
> index 5a65b0cbae7d..198b4c1c3ad3 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -409,8 +409,8 @@ static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
>   static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>   {
>   	if (ipcp->key != IPC_PRIVATE)
> -		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> -				       ipc_kht_params);
> +		WARN_ON_ONCE(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
> +				       ipc_kht_params));
>   }
>   
>   /**
> @@ -425,7 +425,7 @@ void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
>   {
>   	int lid = ipcid_to_idx(ipcp->id);
>   
> -	idr_remove(&ids->ipcs_idr, lid);
> +	WARN_ON_ONCE(idr_remove(&ids->ipcs_idr, lid) != ipcp);
>   	ipc_kht_remove(ids, ipcp);
>   	ids->in_use--;
>   	ipcp->deleted = true;

Tested: With the patch applied, the warning is printed.


--

     manfred

