Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FA1147E93
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgAXKQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:16:19 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:16570 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731492AbgAXKQT (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 24 Jan 2020 05:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1579860975;
        s=strato-dkim-0002; d=plating.de;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=U94wJoXVqkWPknp2l3cH/XsYLAhiUaPTXUQGFi4W9xE=;
        b=HnadJ1CmH/pHB9JD+BS70jPmGLwMo0F+JAN6F28X/p3P5uahOiiRsxTnNRrH48L+An
        tmVzOxJapB+1GpNgf/MTdyykf+Scm4j39QDzPHW2Vw0BB3Fjn6uqHZ6QvFiNCCvZYMWo
        /dWVIuZxU04h5B5Mu3+GXWwKerVq8Sr54JNCgRX/rKliQeiUUJHR52EX7c+S1eREWvqY
        Qt8t0KT/eDs8KBxLGCBz46gfYHXFiBYz208ykG+fPO34RwGT/7tVqWXwVslr06hcyODe
        bdh3LZILJ+foBGRUNSEGNkGLtYLdi+7lEuW7v3bse1oU2S910Uq+MwEhk1q7hVjO3tKm
        lo0Q==
X-RZG-AUTH: ":P2EQZVataeyI5jZ/YFVerR/NeEUpp/1ZEi4FSKT8sA3i0IzVhLiw6JgrUzaKN77axfKEX18="
X-RZG-CLASS-ID: mo00
Received: from mail.dl.plating.de
        by smtp.strato.de (RZmta 46.1.7 AUTH)
        with ESMTPSA id L0b26cw0OAGF4sl
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 24 Jan 2020 11:16:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.dl.plating.de (Postfix) with ESMTP id CD14C122237;
        Fri, 24 Jan 2020 11:16:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at dl.plating.de
Received: from mail.dl.plating.de ([127.0.0.1])
        by localhost (mail.dl.plating.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VK1zqpHJZgs7; Fri, 24 Jan 2020 11:16:08 +0100 (CET)
Received: from [172.16.4.186] (unknown [172.16.4.186])
        by mail.dl.plating.de (Postfix) with ESMTPSA id 582E3120413;
        Fri, 24 Jan 2020 11:16:07 +0100 (CET)
Subject: Re: FAILED: patch "[PATCH] iio: buffer: align the size of scan bytes
 to size of the" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, lars@metafoo.de
References: <157944091042104@kroah.com>
From:   =?UTF-8?Q?Lars_M=c3=b6llendorf?= <lars.moellendorf@plating.de>
Message-ID: <0af6f6ac-174e-6738-d9f7-4bb77f5f63fa@plating.de>
Date:   Fri, 24 Jan 2020 11:16:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <157944091042104@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

as the author of the original patch I just mailed the backport to
Stable@vger.kernel.org (and a lot of others as a result of
`scripts/get_maintainer.pl` and `git send-email`).

However, I don't know if Jonathan and the other maintainers want the
patch applied to the 4.4-stable tree or to any other stable or longterm
tree.

Thanks,
Lars

On 19.01.20 14:35, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 883f616530692d81cb70f8a32d85c0d2afc05f69 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>
> Date: Fri, 13 Dec 2019 14:50:55 +0100
> Subject: [PATCH] iio: buffer: align the size of scan bytes to size of the
>  largest element
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Previous versions of `iio_compute_scan_bytes` only aligned each element
> to its own length (i.e. its own natural alignment). Because multiple
> consecutive sets of scan elements are buffered this does not work in
> case the computed scan bytes do not align with the natural alignment of
> the first scan element in the set.
> 
> This commit fixes this by aligning the scan bytes to the natural
> alignment of the largest scan element in the set.
> 
> Fixes: 959d2952d124 ("staging:iio: make iio_sw_buffer_preenable much more general.")
> Signed-off-by: Lars Möllendorf <lars.moellendorf@plating.de>
> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index c193d64e5217..112225c0e486 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -566,7 +566,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
>  				const unsigned long *mask, bool timestamp)
>  {
>  	unsigned bytes = 0;
> -	int length, i;
> +	int length, i, largest = 0;
>  
>  	/* How much space will the demuxed element take? */
>  	for_each_set_bit(i, mask,
> @@ -574,13 +574,17 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
>  		length = iio_storage_bytes_for_si(indio_dev, i);
>  		bytes = ALIGN(bytes, length);
>  		bytes += length;
> +		largest = max(largest, length);
>  	}
>  
>  	if (timestamp) {
>  		length = iio_storage_bytes_for_timestamp(indio_dev);
>  		bytes = ALIGN(bytes, length);
>  		bytes += length;
> +		largest = max(largest, length);
>  	}
> +
> +	bytes = ALIGN(bytes, largest);
>  	return bytes;
>  }
>  
> 

-- 

Lars Möllendorf, B. Eng.


Tel.:    +49 (0) 7641 93500-425
Fax:     +49 (0) 7641 93500-999
E-Mail:  lars.moellendorf@plating.de <mailto:lars.moellendorf@plating.de>
Website: www.plating.de <http://www.plating.de>

--------------------------------
plating electronic GmbH - Amtsgericht Freiburg - HRB Nr. 260 592 /
Geschäftsführer Karl Rieder / Rheinstraße 4 – 79350 Sexau – Tel.:+49 (0)
7641 – 93500-0

--------------------------------
Der Inhalt dieser E-Mail ist vertraulich und ausschließlich für den
bezeichneten Adressaten bestimmt. Wenn Sie nicht der vorgesehene
Adressat dieser E-Mail oder dessen Vertreter sein sollten, so beachten
Sie bitte, dass jede Form der Kenntnisnahme, Veröffentlichung,
Vervielfältigung oder Weitergabe des Inhalts dieser E-Mail unzulässig
ist. Wir bitten Sie, sich in diesem Fall mit dem Absender der E-Mail in
Verbindung zu setzen. Aussagen gegenüber  dem Adressaten unterliegen den
Regelungen des zugrundeliegenden Angebotes bzw. Auftrags, insbesondere
den Allgemeinen Geschäftsbedingungen und der individuellen
Haftungsvereinbarung. Der Inhalt der E-Mail ist nur rechtsverbindlich,
wenn er unsererseits durch einen Brief oder ein Telefax entsprechend
bestaetigt wird.

The information contained in this email is confidential. It is intended
solely for the addressee. Access to this email by anyone else is
unauthorized. If you are not the intended recipient, any form of
disclosure, reproduction, distribution or any action taken or refrained
from in reliance on it, is prohibited and may be unlawful. Please notify
the sender immediately. All statements of opinion or advice directed via
this email to our clients are subject to the terms and conditions
expressed in the governing client engagement letter. The content of this
email is not legally binding unless confirmed by letter or fax.

Although plating electronic GmbH attempts to sweep e-mail and
attachments for viruses, it does not guarantee that either are
virus-free and accepts no liability for any damage sustained as a result
of viruses.

