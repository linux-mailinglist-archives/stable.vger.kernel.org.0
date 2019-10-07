Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B05CEFB7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbfJGXqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:46:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28560 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729252AbfJGXqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 19:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570491992;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBWMaaGZzF4oSdvKphv04ldIFyjgzUH1UG+ukukd4tA=;
        b=SXTyUTZu0FjirRFil5+clqgwyLpGF7a6YEUDoWK1iiOUOpfuQkCGYJPe3Z41NJ9/3etNNl
        Y/WbiMuNdKSJ/o4buU5RrkiwSLYgIlkJdKmJc8GfLItbwK922hSUA3Bn5liJYAxlld4c04
        CPEydR+ovs+kt8o4DdeA8e3nlSHtUNs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-xvBBqc3JMkuP-mw1MBDzOg-1; Mon, 07 Oct 2019 19:46:30 -0400
Received: by mail-io1-f70.google.com with SMTP id k14so29436830iot.14
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 16:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=bz4UjdSVNp8i1AWweRPklpY8fKMpEuB9OPQPSrcsQNE=;
        b=YkwnYE8GRXrBzME2xEmtQjChzkEo4C+IU+BbfIlg2bhdOjd83YxZREHvf3mWki30a1
         K8M2T45EQlTBGkbD3ADM20y1WUnZBGtR5q8UA8rluRiJi/xCyvIP4cKF2Gl+Y78EZm/L
         lZK5DFyqrgbHOjQQEcy5OSdf8t356DTO+Z3zIMb2VuzNajfcZQsH7LrpfaoaZgq1oC4Q
         nLj5mjbs1mTrvmOPPKC4rMxwDdNa9d1u7zxOYERsFBRt7r3JJ+zeTIk5QqfIU7ZEC27a
         g4NFAArrvWVPBffbVsB6ukjnYhfmQ9BqvYKsncs6oiK8q4X21yDx1x0SvDnBEWjVjD6h
         JbWQ==
X-Gm-Message-State: APjAAAVlhDGTZTnc39Ml1XJRLMAmatt497ScQPD9lPudr/UMT9Sr/tcQ
        XHeReNgCJRwxJgIXJqLNGhY6oJHtyR3uF9ms1kZm2Ga2Ih2AlkpL2bFNZ8LiN2kSitB5jdJPfRk
        cxsKYGYHQew/bFbSn
X-Received: by 2002:a6b:6d07:: with SMTP id a7mr22142814iod.261.1570491989633;
        Mon, 07 Oct 2019 16:46:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxUyzMIKtSVrSSQNpi4VVwUStK1lbTXh/m+TlzldDHOGdeKhuYb3kugOzuLH4UYPPsJE50T9g==
X-Received: by 2002:a6b:6d07:: with SMTP id a7mr22142801iod.261.1570491989440;
        Mon, 07 Oct 2019 16:46:29 -0700 (PDT)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id t17sm6047767ioc.18.2019.10.07.16.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 16:46:28 -0700 (PDT)
Date:   Mon, 7 Oct 2019 16:46:27 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     jarkko.sakkinen@linux.intel.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: add check after commands attribs tab allocation
Message-ID: <20191007234627.fna7s5nvhgpv3bmq@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Tadeusz Struk <tadeusz.struk@intel.com>,
        jarkko.sakkinen@linux.intel.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <157048479752.25182.17480591993061064051.stgit@tstruk-mobl1.jf.intel.com>
MIME-Version: 1.0
In-Reply-To: <157048479752.25182.17480591993061064051.stgit@tstruk-mobl1.jf.intel.com>
User-Agent: NeoMutt/20180716
X-MC-Unique: xvBBqc3JMkuP-mw1MBDzOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon Oct 07 19, Tadeusz Struk wrote:
>devm_kcalloc() can fail and return NULL so we need to check for that.
>
>Fixes: 58472f5cd4f6f ("tpm: validate TPM 2.0 commands")
>Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>---
> drivers/char/tpm/tpm2-cmd.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
>index ba9acae83bff..5817dfe5c5d2 100644
>--- a/drivers/char/tpm/tpm2-cmd.c
>+++ b/drivers/char/tpm/tpm2-cmd.c
>@@ -939,6 +939,10 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chi=
p)
>
> =09chip->cc_attrs_tbl =3D devm_kcalloc(&chip->dev, 4, nr_commands,
> =09=09=09=09=09  GFP_KERNEL);
>+=09if (!chip->cc_attrs_tbl) {
>+=09=09rc =3D -ENOMEM;
>+=09=09goto out;
>+=09}
>
> =09rc =3D tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY)=
;
> =09if (rc)
>

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

