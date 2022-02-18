Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B592B4BC013
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 20:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbiBRTFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 14:05:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiBRTFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 14:05:47 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE793F332
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 11:05:30 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 27so3428015pgk.10
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 11:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=gAYCaWD+I/5K7T2tY1uj7IQZc8/qTYUQZ9JN2xJhQy4=;
        b=gAl9ea7y7aDGUd4LfVvv3BJXWteUiBzDwBBMcqfslZjfajCoSQyAVgItifUxFcWaYX
         KRrjUr27HznusZuV3/OdhfGFKFQH4zIezhJbDb+IK4NEQjPQ7SMLA+1fYOpdsZaK9EtG
         mdVHJM1GeW7YwgjhnHHQC0eiWb4oyTotu9PT7mkHhjPHClZhGu56QO5KKKqE6GgAF3/I
         m4BvBuBE3IMuhY4Gc1H/PfnqSpSmyaEXf6obxBgcjuJaKnxdA7CND3VHYhT4+Xk5S1F2
         hfH24o6jwwoZbA/Uz1SkGrNmgdKECC0zqSjBggjqeruQBnczOmAkV72YCJ0hsbOog/9U
         6igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=gAYCaWD+I/5K7T2tY1uj7IQZc8/qTYUQZ9JN2xJhQy4=;
        b=Vci6o+/Gjz481pbveHrlgdGbCduFiXhJi9QpaLDcU+uAbX1ml81Mx7pPscFz+ChLhI
         OKjCcaAWjtit8AXbfQW20Vcgs9zhIjnzfTi8rB8sI1ui9eaK4KnzjTwMbtRghYnJWf1U
         OYDQASM2KArPnllQqsf189MgYlxOU0u2r/iIkw9wcGKQj8BIyYr3re5HqUe45YfOQcVd
         5pVQgUMZ+epb4iyBus0Ip7AHAbtIxwVbBhNoYzXW+xg4+szWzutuc1pYfWRJAQ+sfxef
         x/WpzeXWDXCeCbKMW37FN3HWV2K6FTMAfR5Bm3iiWFkYLVOzrE5ev9ckKP3Woi93+pj0
         LRsA==
X-Gm-Message-State: AOAM532Pbd3mCmbFNnHp6SEHDUw9X4fZOlNSAXoZnicyGFli2yHuoIVF
        LlUCSSV2uHuQR5b3LrUk49JaIKNungNjeQ==
X-Google-Smtp-Source: ABdhPJxnvdoJHgx60zJ/iaEPQHfenzIfbNpW6GsLihAs6cCbbcEtiqvZx3lJAuB5FfXCkeirikv8rw==
X-Received: by 2002:a63:e249:0:b0:36c:4f1f:95e0 with SMTP id y9-20020a63e249000000b0036c4f1f95e0mr7455930pgj.381.1645211129155;
        Fri, 18 Feb 2022 11:05:29 -0800 (PST)
Received: from google.com ([2620:15c:202:201:f0e:4aa7:e49d:40ba])
        by smtp.gmail.com with ESMTPSA id q32sm12117689pgm.26.2022.02.18.11.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:05:28 -0800 (PST)
Date:   Fri, 18 Feb 2022 11:05:22 -0800
From:   Benson Leung <bleung@google.com>
To:     groeck@chromium.org, Gwendal Grignou <gwendal@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        chrome-platform@lists.linux.dev
Subject: Re: [PATCH v2] platform: chrome: Split trace include file
Message-ID: <164520969269.1961415.11106993009131121558.b4-ty@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kdTR9wP4hx2yOsAa"
Content-Disposition: inline
In-Reply-To: <20220122001301.640337-1-gwendal@chromium.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kdTR9wP4hx2yOsAa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gwendal,

On Fri, 21 Jan 2022 16:13:01 -0800, Gwendal Grignou wrote:
> cros_ec_trace.h defined 5 tracing events, 2 for cros_ec_proto and
> 3 for cros_ec_sensorhub_ring.
> These 2 files are in different kernel modules, the traces are defined
> twice in the kernel which leads to problem enabling only some traces.
>=20
> Move sensorhub traces from cros_ec_trace.h to cros_ec_sensorhub_trace.h
> and enable them only in cros_ec_sensorhub kernel module.
>=20
> [...]

Applied, thanks!

[1/1] platform: chrome: Split trace include file
      commit: 4c288c88d0169120a2de6041c81017585f7ee556

Best regards,
--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--kdTR9wP4hx2yOsAa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQCtZK6p/AktxXfkOlzbaomhzOwwgUCYg/t8gAKCRBzbaomhzOw
wqpRAQCb6ibNDwJShPC0QeefgTWSXYYf0/3CkRaMSUm36OyfWAEAqc00squXgI2r
WZDX57n6wR6eFpN4EoWgLnzH8rGL5wQ=
=MnDv
-----END PGP SIGNATURE-----

--kdTR9wP4hx2yOsAa--
