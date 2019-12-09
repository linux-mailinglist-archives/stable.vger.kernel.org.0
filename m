Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A981178E7
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfLIVzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:55:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbfLIVzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 16:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575928547;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvUwYk7XYnhVb8z+n/0PN8JFHiNkwWG7PVOySQ7OnAY=;
        b=QCeDoRcg73hQUk5nN8AUGGSYu13i+JFcY5Eyq3m2qnQQY87mJzorHaZS9sCXF8ko5ojheH
        J4vjuo+BaRe1Usg7I1LfmzjIV7NsGPbL5p3Ulei9TnwQ5/9BORPwoa/xQVZsCUUY4tWOFu
        NCfyeYiP/BJy1LHlkH+n6J58C9XDzzM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-Jrnip_RiN9Ck4akOO8mZ0g-1; Mon, 09 Dec 2019 16:55:43 -0500
Received: by mail-qt1-f198.google.com with SMTP id o24so466243qtr.17
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 13:55:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LAlWxB0yFY54ciHDGB1TZgCbDYqMZXZ8KAXo988Qmv8=;
        b=i/BlnUKJOHZMCg1scI6nyqdOnGq0+0WhwBS1q0G8b9ik38blCddUFbirUwEXRWfh5l
         D/fc92y+UYBtXFtg5qmpmdHl2KkFjbMCl2LxzBD17E6/KWF3tQfDwIDeBncWrQoRvb+2
         mHlf1qacAANnhF8LZA2bi/gndjRBQRY3EGixAfq5VGXbAu13wapEiS9QmyoMMpXzpSPe
         QjWXCDaUPQ3HC+YzNgjSrD1FR4o/KBXVDlQPSUNGVfAiI0a5QAGl1LrRtVVw1wEKttHW
         W46NQtcdnDxLjE4kcRFzCQLLxBpMqY2HFooKi5vWj+/3Ce192DJBckK7WpT2m03SL4lh
         KXLA==
X-Gm-Message-State: APjAAAWDgrCWm4ITce4rwqPFL6ID3fzMiGamzlOjQRIhgz9POgfDNQWs
        bZDSLIS37C6uDPwBlfOWoz6/N1hMVrlPcjOdXh3bw1hsQJGapz3tjMGyyGrOP6X3IkTtwcuowU9
        hjHxuY32fL68ZR2J6
X-Received: by 2002:a0c:ada3:: with SMTP id w32mr24879210qvc.99.1575928543181;
        Mon, 09 Dec 2019 13:55:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHowXkavZQkKYqUB9IbaWdjd/W1CJgeGzAniL645TlGerE333C9O+ldy7Rdcjs3p1yhtWGBQ==
X-Received: by 2002:a0c:ada3:: with SMTP id w32mr24879192qvc.99.1575928542771;
        Mon, 09 Dec 2019 13:55:42 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id y187sm277800qkd.11.2019.12.09.13.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 13:55:41 -0800 (PST)
Date:   Mon, 9 Dec 2019 14:55:35 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Stefan Berger <stefanb@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/2] Revert patches fixing probing of interrupts
Message-ID: <20191209215535.pw6ewyetskaet2o6@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20191126131753.3424363-1-stefanb@linux.vnet.ibm.com>
 <20191129223418.GA15726@linux.intel.com>
 <6f6f60a2-3b55-e76d-c11a-4677fcb72c16@linux.ibm.com>
 <20191202185520.57w2h3dgs5q7lhob@cantor>
 <20191209194248.GC19243@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20191209194248.GC19243@linux.intel.com>
X-MC-Unique: Jrnip_RiN9Ck4akOO8mZ0g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon Dec 09 19, Jarkko Sakkinen wrote:
>On Mon, Dec 02, 2019 at 11:55:20AM -0700, Jerry Snitselaar wrote:
>> On Sun Dec 01 19, Stefan Berger wrote:
>> > On 11/29/19 5:37 PM, Jarkko Sakkinen wrote:
>> > > On Tue, Nov 26, 2019 at 08:17:51AM -0500, Stefan Berger wrote:
>> > > > From: Stefan Berger <stefanb@linux.ibm.com>
>> > > >
>> > > > Revert the patches that were fixing the probing of interrupts due
>> > > > to reports of interrupt stroms on some systems
>> > > Can you explain how reverting is going to fix the issue?
>> >
>> >
>> > The reverts fix 'the interrupt storm issue' that they are causing on
>> > some systems but don't fix the issue with the interrupt mode not being
>> > used. I was hoping Jerry would get access to a system faster but this
>> > didn't seem to be the case. So sending these patches seemed the better
>> > solution than leaving 5.4.x with the problem but going back to when it
>> > worked 'better.'
>> >
>>
>> I finally heard back from IT support, and unfortunately they don't
>> have any T490s systems to give out on temp loan. So I can only send
>> patched kernels to the end user that had the problem.
>
>At least it is a fact that tpm_chip_stop() is called too early and that
>is destined to cause issues.
>
>Should I bake a patch or do you have already something?
>
>/Jarkko
>

This is what I'm currently building:

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_cor=
e.c
index 270f43acbb77..17184c07eb51 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -899,13 +899,13 @@ int tpm_tis_core_init(struct device *dev, struct tpm_=
tis_data *priv, int irq,
 =20
  =09if (wait_startup(chip, 0) !=3D 0) {
  =09=09rc =3D -ENODEV;
-=09=09goto out_err;
+=09=09goto out_start;
  =09}
 =20
  =09/* Take control of the TPM's interrupt hardware and shut it off */
  =09rc =3D tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
  =09if (rc < 0)
-=09=09goto out_err;
+=09=09goto out_start;
 =20
  =09intmask |=3D TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
  =09=09   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
@@ -914,9 +914,8 @@ int tpm_tis_core_init(struct device *dev, struct tpm_ti=
s_data *priv, int irq,
 =20
  =09rc =3D tpm_chip_start(chip);
  =09if (rc)
-=09=09goto out_err;
+=09=09goto out_start;
  =09rc =3D tpm2_probe(chip);
-=09tpm_chip_stop(chip);
  =09if (rc)
  =09=09goto out_err;
 =20
@@ -980,7 +979,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_ti=
s_data *priv, int irq,
  =09=09=09goto out_err;
  =09=09}
 =20
-=09=09tpm_chip_start(chip);
  =09=09chip->flags |=3D TPM_CHIP_FLAG_IRQ;
  =09=09if (irq) {
  =09=09=09tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
@@ -991,18 +989,17 @@ int tpm_tis_core_init(struct device *dev, struct tpm_=
tis_data *priv, int irq,
  =09=09} else {
  =09=09=09tpm_tis_probe_irq(chip, intmask);
  =09=09}
-=09=09tpm_chip_stop(chip);
  =09}
+=09tpm_chip_stop(chip);
 =20
  =09rc =3D tpm_chip_register(chip);
  =09if (rc)
-=09=09goto out_err;
-
-=09if (chip->ops->clk_enable !=3D NULL)
-=09=09chip->ops->clk_enable(chip, false);
+=09=09goto out_start;
 =20
  =09return 0;
  out_err:
+=09tpm_chip_stop(chip);
+out_start:
  =09if ((chip->ops !=3D NULL) && (chip->ops->clk_enable !=3D NULL))
  =09=09chip->ops->clk_enable(chip, false);

