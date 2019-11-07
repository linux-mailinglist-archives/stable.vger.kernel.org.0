Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23861F3C63
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfKHAAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:00:22 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37144 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKHAAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 19:00:21 -0500
Received: by mail-oi1-f195.google.com with SMTP id y194so3701562oie.4
        for <stable@vger.kernel.org>; Thu, 07 Nov 2019 16:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nigauri-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Pd1OqiXsmcqTn3Q2mZSjzPlC+jFDtPHHd7+uxBE0rYk=;
        b=M903f3VDQQl0z14KvjUE+dO0i3QUwemA1qmRdzH+yqzRHEx9Ah0akgtveZfFD9QHX4
         qtiz1ki5VBh30nOsWU92rGI/n2YbrJ89C54+p9+t5cMLR+M0EBxCKqbS41TlpnTv4qb7
         dpnspv5x69jq2lZ135qZmEHouq034WAEud1klqo005MuswAVp3yvTGPzVVTssbXodiKn
         Dbr+9X8Z4gX6j8sxQU+z7+dPzPBm+fqCD9QL5ns7EKpodNVV0v0pCNME2LEIGIIq8vMW
         x4a2NHV6VmJVpHj64mv4KZxTVGbCwfck1QlybFMrfa+I62Ks/auig/dV2K07kVhV4TJG
         IV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Pd1OqiXsmcqTn3Q2mZSjzPlC+jFDtPHHd7+uxBE0rYk=;
        b=LGOxbrveqV8TceorUr2atI2WCHcbMA06coTQsn1b8mQAvNt4bpoTy3O37slNnZ8GyP
         qcDmYc4LS7Zl+K4Se2OJIawXYgZPjUePaaz8PTBJx4YlGFgYneWjBzy2sBscUxtWgQsg
         3aItVNcig0qjgcdXQjDac3xHv4UBnV6tDId0tuHAv5+I0kckZb2PjbQ1hRaw7ianiRpp
         CmXkoB0J2lPuwLZIqwxDOVxyrqrxtlribeKiIotoBKNz+KmZhWFmpRZaABzLWszZaAXt
         Ojw6/X+tTjydRgQd0pjxfW7Vd4/nKarCcs6qx3Sszkr8TzxNiuKfJRYfyi7oNN/vZDn2
         V/iw==
X-Gm-Message-State: APjAAAXvL08tBJjJPYtExH2YlRXCM3EadXP0jg67W1bzzCqKVogVVB0S
        FbhluLw/1f0zpLTgujoWVFrEpU2IS3HHFIKh94xl
X-Google-Smtp-Source: APXvYqxNVYN5HZzdnwGDnURvn3cahpf0f6mJnFtMPf/Mdb7r9wkh1ngORWNu0lcOffilM+4DRPBXNYEYUZ+QhxLZQtU=
X-Received: by 2002:aca:fdc3:: with SMTP id b186mr6616555oii.92.1573171221007;
 Thu, 07 Nov 2019 16:00:21 -0800 (PST)
MIME-Version: 1.0
References: <20191107170530.6115-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20191107170530.6115-1-andriy.shevchenko@linux.intel.com>
From:   Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date:   Fri, 8 Nov 2019 08:59:54 +0900
Message-ID: <CABMQnVJynuGH-m_jUPsDD7mtDDiY5nTTowubWxd=h4OJaeESHA@mail.gmail.com>
Subject: Re: [PATCH v1] platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E to
 critclk_systems DMI table
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

2019=E5=B9=B411=E6=9C=888=E6=97=A5(=E9=87=91) 2:05 Andy Shevchenko <andriy.=
shevchenko@linux.intel.com>:
>
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> The SIMATIC IPC227E uses the PMC clock for on-board components and gets
> stuck during boot if the clock is disabled. Therefore, add this device
> to the critical systems list.

You forgot to add original commit ID.

Best regards,
  Nobuhiro

>
> Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>
> - resend for stable inclusion
>
>  drivers/platform/x86/pmc_atom.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_a=
tom.c
> index aa53648a2214..9aca5e7ce6d0 100644
> --- a/drivers/platform/x86/pmc_atom.c
> +++ b/drivers/platform/x86/pmc_atom.c
> @@ -415,6 +415,13 @@ static const struct dmi_system_id critclk_systems[] =
=3D {
>                         DMI_MATCH(DMI_BOARD_NAME, "CB6363"),
>                 },
>         },
> +       {
> +               .ident =3D "SIMATIC IPC227E",
> +               .matches =3D {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "SIEMENS AG"),
> +                       DMI_MATCH(DMI_PRODUCT_VERSION, "6ES7647-8B"),
> +               },
> +       },
>         { /*sentinel*/ }
>  };
>
> --
> 2.24.0
>


--
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
