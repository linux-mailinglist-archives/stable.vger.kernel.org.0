Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD93314107
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhBHUyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 15:54:51 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41063 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235296AbhBHUxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 15:53:49 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2021 15:53:48 EST
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 9DQvljoPhefbk9DQyl6Qwn; Mon, 08 Feb 2021 21:47:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1612817221; bh=hBtbVvAGLO4OYj5idcoGs6+65GhkktNma5gOZmEtlho=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=gb7GKpbCxUvGUroLptUEEfODKhxNzlpog9ZOj9u/VDQNDOsYxHM1Lg1yr7ETpWEgu
         9dgxkAT+k/8BbpdnDuc6skxpMT31Ebpd3L6JdRjqCeTQK3+U2x8tPJttpI8hnoEztw
         EDZrGbu4Y5v/DfMDpFVYU/aAGai+Db+RqqjH/Qjw1INA8cJECjWBGK2IE+rJXz8wxo
         WfJz2vi7Y9MqfwRJ0DaXwcnQcx1/NtfyHTewuhPcJmq5XT6IUAB3oEpHSU+5Nyu45+
         X8+72rEJ3y/gwPtUmN/dN9fZn4fQZwohY0D0Ei03uFFidl8L5Fj1g2Mzx2+FN/SxLa
         TeBdhUTLd+UDg==
Subject: Re: [PATCH AUTOSEL 5.10 14/36] media: rkisp1: uapi: change hist_bins
 array type from __u16 to __u32
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <20210208175806.2091668-1-sashal@kernel.org>
 <20210208175806.2091668-14-sashal@kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <12c8f50e-3bba-5936-6e67-55bd928a75c7@xs4all.nl>
Date:   Mon, 8 Feb 2021 21:46:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210208175806.2091668-14-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfJhCeXUzkkqo0jowHBlu9YVGkP/aghLIMh5Hkta0qWJeAWbHKN24RajccQ2yh7Zx/DpycHW76g4/m1ZTzeFTVt0CyWVY01DtTR+0DDvKDrfKsbXluWUF
 rFjWHQScFO16gKpQAQv86bhaa6kuQ/37VCKQbcRjucuopqxEy1eS3mGLd+cVjdp1hUGev6lEifcfBiye8nKL2d7z0TPn9vxTd0cummmqITqE9uHQqcdROt/e
 dZzJosd9arQlhI1gAmJoXOOEPVZtuhQ7lTrrjyU2mUWJmK+aTq/OeoNZHmzOVoj5bnfWB65Lr5iASsskDg7o7Y3Q7P39cYHMl+lKlJfaupDhI8Xp9AHfMNIX
 7qQxWhB1BaCdxAxA/NohsX+tbbWpJ3GgM2Q16xsTW2YFf+O0e7buN3Oh1T+1n4wM8IJfy5Bq1htMaPppGKdnD/q42g0Jgt8kKgBFjcnCc3QzH1P/U04=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/02/2021 18:57, Sasha Levin wrote:
> From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> 
> [ Upstream commit 31f190e0ccac8b75d33fdc95a797c526cf9b149e ]
> 
> Each entry in the array is a 20 bits value composed of 16 bits unsigned
> integer and 4 bits fractional part. So the type should change to __u32.
> In addition add a documentation of how the measurements are done.

Dafna, Helen, does it make sense at all to backport these three patches to
when rkisp1 was a staging driver?

I would be inclined not to backport this.

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> Acked-by: Helen Koike <helen.koike@collabora.com>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/media/rkisp1/uapi/rkisp1-config.h | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/rkisp1/uapi/rkisp1-config.h b/drivers/staging/media/rkisp1/uapi/rkisp1-config.h
> index 432cb6be55b47..c19fe059c2442 100644
> --- a/drivers/staging/media/rkisp1/uapi/rkisp1-config.h
> +++ b/drivers/staging/media/rkisp1/uapi/rkisp1-config.h
> @@ -848,13 +848,18 @@ struct rkisp1_cif_isp_af_stat {
>  /**
>   * struct rkisp1_cif_isp_hist_stat - statistics histogram data
>   *
> - * @hist_bins: measured bin counters
> + * @hist_bins: measured bin counters. Each bin is a 20 bits unsigned fixed point
> + *	       type. Bits 0-4 are the fractional part and bits 5-19 are the
> + *	       integer part.
>   *
> - * Measurement window divided into 25 sub-windows, set
> - * with ISP_HIST_XXX
> + * The window of the measurements area is divided to 5x5 sub-windows. The
> + * histogram is then computed for each sub-window independently and the final
> + * result is a weighted average of the histogram measurements on all
> + * sub-windows. The window of the measurements area and the weight of each
> + * sub-window are configurable using struct @rkisp1_cif_isp_hst_config.
>   */
>  struct rkisp1_cif_isp_hist_stat {
> -	__u16 hist_bins[RKISP1_CIF_ISP_HIST_BIN_N_MAX];
> +	__u32 hist_bins[RKISP1_CIF_ISP_HIST_BIN_N_MAX];
>  };
>  
>  /**
> 

