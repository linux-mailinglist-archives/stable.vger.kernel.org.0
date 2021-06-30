Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2623B8170
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhF3LtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 07:49:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42838 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3LtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 07:49:06 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F068C1FE78;
        Wed, 30 Jun 2021 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625053596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJlJKRCeEkCggsWzP6gvoOKOja7JUXFm1Gs9/8pxrws=;
        b=tJGnx50LItyXg+3ay7yc5RxaubPmuUJ2C6VEeJRSmR7KVoZd3twsQqmIILl5q5yHqjUNSc
        bPo/EVCReukxBjMnFenqiIGIXyoKJK3KnEt8zSEBB0DUjNtK0D9XuGGcpomqaRfwUkwT3p
        GXU6EwCx+BWRNBgQnxMU9sESnysLWV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625053596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJlJKRCeEkCggsWzP6gvoOKOja7JUXFm1Gs9/8pxrws=;
        b=BH/5z9IcCR4lrwkENCPdTwZF+sspQ8TL9VzmrE61rdFbANMPsJSNuyx5UMJBtSnn267tGv
        aZw6yqAABSPwQ/AA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BED97118DD;
        Wed, 30 Jun 2021 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625053596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJlJKRCeEkCggsWzP6gvoOKOja7JUXFm1Gs9/8pxrws=;
        b=tJGnx50LItyXg+3ay7yc5RxaubPmuUJ2C6VEeJRSmR7KVoZd3twsQqmIILl5q5yHqjUNSc
        bPo/EVCReukxBjMnFenqiIGIXyoKJK3KnEt8zSEBB0DUjNtK0D9XuGGcpomqaRfwUkwT3p
        GXU6EwCx+BWRNBgQnxMU9sESnysLWV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625053596;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJlJKRCeEkCggsWzP6gvoOKOja7JUXFm1Gs9/8pxrws=;
        b=BH/5z9IcCR4lrwkENCPdTwZF+sspQ8TL9VzmrE61rdFbANMPsJSNuyx5UMJBtSnn267tGv
        aZw6yqAABSPwQ/AA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 3PCMLZxZ3GC3OQAALh3uQQ
        (envelope-from <tzimmermann@suse.de>); Wed, 30 Jun 2021 11:46:36 +0000
Subject: Re: [PATCH v3 2/2] drm/i915: Drop all references to DRM IRQ midlayer
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     matthew.brost@intel.com, airlied@linux.ie,
        mika.kuoppala@linux.intel.com, intel-gfx@lists.freedesktop.org,
        chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        lucas.demarchi@intel.com
References: <20210630095228.6665-1-tzimmermann@suse.de>
 <20210630095228.6665-3-tzimmermann@suse.de> <YNxCHDGA+x2Xe9pM@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <f705e5a3-b7fb-fe56-f125-f14205c50fbc@suse.de>
Date:   Wed, 30 Jun 2021 13:46:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNxCHDGA+x2Xe9pM@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AhhbWt4vrssvgdxfMnbJHBB34rATnM0Rf"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AhhbWt4vrssvgdxfMnbJHBB34rATnM0Rf
Content-Type: multipart/mixed; boundary="3S6GyhA9ETC7gdifDc31QiS0vgvwdsfJb";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: matthew.brost@intel.com, airlied@linux.ie, mika.kuoppala@linux.intel.com,
 intel-gfx@lists.freedesktop.org, chris@chris-wilson.co.uk,
 dri-devel@lists.freedesktop.org, rodrigo.vivi@intel.com,
 stable@vger.kernel.org, lucas.demarchi@intel.com
Message-ID: <f705e5a3-b7fb-fe56-f125-f14205c50fbc@suse.de>
Subject: Re: [PATCH v3 2/2] drm/i915: Drop all references to DRM IRQ midlayer
References: <20210630095228.6665-1-tzimmermann@suse.de>
 <20210630095228.6665-3-tzimmermann@suse.de> <YNxCHDGA+x2Xe9pM@kroah.com>
In-Reply-To: <YNxCHDGA+x2Xe9pM@kroah.com>

--3S6GyhA9ETC7gdifDc31QiS0vgvwdsfJb
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 30.06.21 um 12:06 schrieb Greg KH:
> On Wed, Jun 30, 2021 at 11:52:28AM +0200, Thomas Zimmermann wrote:
>> Remove all references to DRM's IRQ midlayer. i915 uses Linux' interrup=
t
>> functions directly.
>>
>> v2:
>> 	* also remove an outdated comment
>> 	* move IRQ fix into separate patch
>> 	* update Fixes tag (Daniel)
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: b318b82455bd ("drm/i915: Nuke drm_driver irq vfuncs")
>> Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: <stable@vger.kernel.org> # v5.4+
>> ---
>>   drivers/gpu/drm/i915/i915_drv.c | 1 -
>>   drivers/gpu/drm/i915/i915_irq.c | 5 -----
>>   2 files changed, 6 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i9=
15_drv.c
>> index 850b499c71c8..73de45472f60 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.c
>> +++ b/drivers/gpu/drm/i915/i915_drv.c
>> @@ -42,7 +42,6 @@
>>   #include <drm/drm_aperture.h>
>>   #include <drm/drm_atomic_helper.h>
>>   #include <drm/drm_ioctl.h>
>> -#include <drm/drm_irq.h>
>>   #include <drm/drm_managed.h>
>>   #include <drm/drm_probe_helper.h>
>>  =20
>> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i9=
15_irq.c
>> index 2203dca19895..1d4c683c9de9 100644
>> --- a/drivers/gpu/drm/i915/i915_irq.c
>> +++ b/drivers/gpu/drm/i915/i915_irq.c
>> @@ -33,7 +33,6 @@
>>   #include <linux/sysrq.h>
>>  =20
>>   #include <drm/drm_drv.h>
>> -#include <drm/drm_irq.h>
>>  =20
>>   #include "display/intel_de.h"
>>   #include "display/intel_display_types.h"
>> @@ -4564,10 +4563,6 @@ void intel_runtime_pm_enable_interrupts(struct =
drm_i915_private *dev_priv)
>>  =20
>>   bool intel_irqs_enabled(struct drm_i915_private *dev_priv)
>>   {
>> -	/*
>> -	 * We only use drm_irq_uninstall() at unload and VT switch, so
>> -	 * this is the only thing we need to check.
>> -	 */
>>   	return dev_priv->runtime_pm.irqs_enabled;
>>   }
>>  =20
>> --=20
>> 2.32.0
>>
>=20
> How is this a stable-kernel-related fix?

Sorry, it isn't. I forgot to remove the rsp Cc tag.

Best regards
Thomas

>=20
> thanks,
>=20
> greg k-h
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--3S6GyhA9ETC7gdifDc31QiS0vgvwdsfJb--

--AhhbWt4vrssvgdxfMnbJHBB34rATnM0Rf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmDcWZwFAwAAAAAACgkQlh/E3EQov+A2
ew/+Mj6/gdeqqVkIBhzsJb9KT8UBkWGzxg38FP4FNtE1dzU/3Ej3cZqns09ga7Jgx7CJQNkDDmVk
DT4IVotp6d+0vUjm4IrBHf4YrfM1HFfWb0xlwPz5Ku7GbAfwL7JVEoOc/zx7oJyWwx5xmwOWpoQ6
SUynEmC4/G9Hwd8YpH66u+26bVNb/94ungvIT1ag7wwMSmNZTHHPAz3MXLEMW7ExCNRXhaAR+ELm
CH4Qu3KUO1BgAuS7bAs4xBWq+S7SEnL3cj5XJ56GQYJYtILhSQ5coIjY5Py9Rkw4niQQMBNaYrh9
/TLUTDtPjXOkTNhEbb2wD6MvzxgTx42nV0oVjNDYpqefMxdAvs3GHfsWL73Q/Pe35B6WRzsYZ8ie
L3A9wIrdrwoR945Gpp+iepECiiM6bDyWsLOFg9I2IHuYhsaAQmXJN1OCFe6EqNOT/Nm+i3I9HAGw
+SG1ufL3CjxBvMI5DinnmeKHIaQIo7Zjc8uXjj8zJeLJgzMZ9Y5pe/UYf2d7haMZ3HdUfq6pNTPE
GU+7t0+jOB1hQhWtJbmTrOqyNNFT50g+woAPjEU/GzNxzk4ufwkr1v6IGM4bfA09/lFQ9XgKIV/0
89LwaGDgDdv1LsR4oTvUBjuSUt1IKdijI0Bdw90zE30EThRSF4wz4ugIvrwzAmWjdEsW4A0bO/zu
fUA=
=RLlo
-----END PGP SIGNATURE-----

--AhhbWt4vrssvgdxfMnbJHBB34rATnM0Rf--
