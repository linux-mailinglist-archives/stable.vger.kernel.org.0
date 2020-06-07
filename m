Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C61F1057
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 01:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgFGXLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 19:11:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726922AbgFGXLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 19:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591571480;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=KSlntCbluVS76b3g/z4HXEV6a3OnchHRiFcS+IdPIFA=;
        b=DSTPA4DZ8Qu+wSFZZBX7utYaDkxK2ulvT92zGjUPzENGp5ty5djYtUNmm22tDaAR/pSMp/
        phw/dis3cV06JfRpnDS0+BOus1+jQduL62HmX9SXxds2dKeyJrAk8gEB921Lke+9A+f6/f
        DeDllDo3wkXCYDYJchd1dffQ4/MBE6c=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-GEmjF7QxPgiThsG_mdUklA-1; Sun, 07 Jun 2020 19:11:18 -0400
X-MC-Unique: GEmjF7QxPgiThsG_mdUklA-1
Received: by mail-qt1-f198.google.com with SMTP id x6so14005578qts.3
        for <stable@vger.kernel.org>; Sun, 07 Jun 2020 16:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=KSlntCbluVS76b3g/z4HXEV6a3OnchHRiFcS+IdPIFA=;
        b=SbT2CeV4N3QGm4yJ1/F/kuF34dxQUAcrbdtgM0o0tTDWAB8pXmCtxd0houizKM0+gd
         rgivAu/3hY1Al48bOYvpUlf+6Mh+SXuQeDsPW1igQ0pWT6sRPhvdRMU5Fedarp870eEx
         GHaAQkO+AyTkPXFK29Lg9Bo6J4LnUc2Rf9qn2+swZl6EnZshZPnZQa4D/ToyKITAvKHC
         PkU1yYXgDBf8o+3pGCFQ1WXvAO9tMGaFomiRb4cH51aoGogr+rk8VJ16ET2o+VSJ5gVT
         DEREU9VzXc6UJouXRriMmGuJD0VDCZHNzsdeU2J+S0EHdTDE1NCzpXrtbkGZS1LOMYH6
         g3ug==
X-Gm-Message-State: AOAM5339BNJLJeEUbcmwdYQ2f+8wol0N43c92oiX553Xgh5EO5w2dzqF
        YBVIlZY0snvlBTGNAK+WsTzJWD1HSZl25Eu+3LaDLI4BPABr1v+Il4PWPrgtkNpYVkLK/7vJkJu
        mIptYncCCkxMX35lU
X-Received: by 2002:ac8:5648:: with SMTP id 8mr20542599qtt.280.1591571475455;
        Sun, 07 Jun 2020 16:11:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpekLdyoLa9wr0qytkS/wYSsoLBrj0PEk8/q8fKvEGGc7LPHx1/CyhX1FGA6tWiJ6toLo+tQ==
X-Received: by 2002:ac8:5648:: with SMTP id 8mr20542575qtt.280.1591571475209;
        Sun, 07 Jun 2020 16:11:15 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id b4sm5249646qka.133.2020.06.07.16.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 16:11:14 -0700 (PDT)
Date:   Sun, 7 Jun 2020 16:11:13 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     torvalds@linux-foundation.org, zohar@linux.ibm.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH] ima: Remove __init annotation from ima_pcrread()
Message-ID: <20200607231113.mocsa7wphkpleh7a@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Roberto Sassu <roberto.sassu@huawei.com>,
        torvalds@linux-foundation.org, zohar@linux.ibm.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
References: <20200607210029.30601-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20200607210029.30601-1-roberto.sassu@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun Jun 07 20, Roberto Sassu wrote:
>Commit 6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in
>ima_eventdigest_init()") added a call to ima_calc_boot_aggregate() so that
>the digest can be recalculated for the boot_aggregate measurement entry if
>the 'd' template field has been requested. For the 'd' field, only SHA1 and
>MD5 digests are accepted.
>
>Given that ima_eventdigest_init() does not have the __init annotation, all
>functions called should not have it. This patch removes __init from
>ima_pcrread().
>
>Cc: stable@vger.kernel.org
>Fixes:  6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()")
>Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

>---
> security/integrity/ima/ima_crypto.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>index ba5cc3264240..220b14920c37 100644
>--- a/security/integrity/ima/ima_crypto.c
>+++ b/security/integrity/ima/ima_crypto.c
>@@ -786,7 +786,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
> 	return calc_buffer_shash(buf, len, hash);
> }
>
>-static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
>+static void ima_pcrread(u32 idx, struct tpm_digest *d)
> {
> 	if (!ima_tpm_chip)
> 		return;
>-- 
>2.17.1
>

