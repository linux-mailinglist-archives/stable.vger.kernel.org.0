Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0B24AA865
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 12:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiBELkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 06:40:42 -0500
Received: from mail.ispras.ru ([83.149.199.84]:54668 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232509AbiBELkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Feb 2022 06:40:41 -0500
Received: from [10.10.2.52] (unknown [10.10.2.52])
        by mail.ispras.ru (Postfix) with ESMTPSA id 90B0840D3BFF;
        Sat,  5 Feb 2022 11:40:37 +0000 (UTC)
Subject: Re: [PATCH 5.10 12/25] drm/vc4: hdmi: Make sure the device is powered
 with CEC
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.688259001@linuxfoundation.org>
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
Autocrypt: addr=khoroshilov@ispras.ru; prefer-encrypt=mutual; keydata=
 xsFNBFtq9eIBEACxmOIPDht+aZvO9DGi4TwnZ1WTDnyDVz3Nnh0rlQCK8IssaT6wE5a95VWo
 iwOWalcL9bJMHQvw60JwZKFjt9oH2bov3xzx/JRCISQB4a4U1J/scWvPtabbB3t+VAodF5KZ
 vZ2gu/Q/Wa5JZ9aBH0IvNpBAAThFg1rBXKh7wNqrhsQlMLg+zTSK6ZctddNl6RyaJvAmbaTS
 sSeyUKXiabxHn3BR9jclXfmPLfWuayinBvW4J3vS+bOhbLxeu3MO0dUqeX/Nl8EAhvzo0I2d
 A0vRu/Ze1wU3EQYT6M8z3i1b3pdLjr/i+MI8Rgijs+TFRAhxRw/+0vHGTg6Pn02t0XkycxQR
 mhH3v0kVTvMyM7YSI7yXvd0QPxb1RX9AGmvbJu7eylzcq9Jla+/T3pOuWsJkbvbvuFKKmmYY
 WnAOR7vu/VNVfiy4rM0bfO14cIuEG+yvogcPuMmQGYu6ZwS9IdgZIOAkO57M/6wR0jIyfxrG
 FV3ietPtVcqeDVrcShKyziRLJ+Xcsg9BLdnImAqVQomYr27pyNMRL5ILuT7uOuAQPDKBksK+
 l2Fws0d5iUifqnXSPuYxqgS4f8SQLS7ECxvCGVVbkEEng9vkkmyrF6wM86BZ9apPGDFbopiK
 7GRxQtSGszVv83abaVb8aDsAudJIp7lLaIuXLZAe1r+ycYpEtQARAQABzSpBbGV4ZXkgS2hv
 cm9zaGlsb3YgPGtob3Jvc2hpbG92QGlzcHJhcy5ydT7CwX0EEwEIACcFAltq9eICGwMFCRLM
 AwAFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ2B/JSzCwrEWLaA/+NFZfyhU0vJzFtYsk
 yaqx8nWZLrAoUK7VcobH0lJH6lfGbarO5JpENaIiTP12YZ4xO+j3GGJtLy2gvnpypGnxmiAl
 RqPt7WeAIj6oqPrUs2QF7i4SOiPtku/NrysI1zHzlA8yqUduBtam5rdQeLRNCJiEED1fU8sp
 +DgJBN/OHEDyAag2hu1KFKWuPfQ+QGpXYZb+1NW/hKwvvwCNVyypELAfFnkketFXjIMwHnL8
 ZPqJZlkvkpxuRXOaXPL9NFhZnC/WS+NJ81L3pr+w6eo3xTPYZvRW8glvqlEDgHqr3uMGIaes
 nwfRXLHp+TC1ht6efCXzdPyMZ1E7HXQN9foKisI1V5iQFhN+CT3dbsguQI4e10F5ql0TZUJY
 SMzvY0eObs6TWRdD/Ha7Y5rLmZ54R9sxumpZNcJzktfgm9f0XfeqVEJUn/40MRDD+l2W12Db
 Jkko+sbtAEw+f+/j3uz8xOE+Uv4kwFC5a6JKgdX88oigHnpAs3FvffP594Loi3ibFrQUW5wH
 bXh5Ni+l1GKEQ0PHMk+KQQT9L2r9s7C0Nh8XzwdpOshZWsrNSZqcG+01wrmUhyX2uSaoZ07I
 /+KZURlMSqI71X6lkMWlB3SyThvYhHgnR0EGGTerwM1MaVjHN+Z6lPmsKNxG8lzCeWeZ6peA
 c5oUHV4WQ8Ux9BM8saLOwU0EW2r14gEQAMz+5u+X7j1/dT4WLVRQaE1Shnd2dKBn2E7fgo/N
 4JIY6wHD/DJoWYQpCJjjvBYSonvQsHicvDW8lPh2EXgZ9Fi8AHKT2mVPitVy+uhfWa/0FtsC
 e3hPfrjTcN7BUcXlIjmptxIoDbvQrNfIWUGdWiyDj4EDfABW/kagXqaBwF2HdcDaNDGggD1c
 DglA0APjezIyTGnGMKsi5QSSlOLm8OZEJMj5t+JL6QXrruijNb5Asmz5mpRQrak7DpGOskjK
 fClm/0oy2zDvWuoXJa+dm3YFr43V+c5EIMA4LpGk63Eg+5NltQ/gj0ycgD5o6reCbjLz4R9D
 JzBezK/KOQuNG5qKUTMbOHWaApZnZ6BDdOVflkV1V+LMo5GvIzkATNLm/7Jj6DmYmXbKoSAY
 BKZiJWqzNsL1AJtmJA1y5zbWX/W4CpNs8qYMYG8eTNOqunzopEhX7T0cOswcTGArZYygiwDW
 BuIS83QRc7udMlQg79qyMA5WqS9g9g/iodlssR9weIVoZSjfjhm5NJ3FmaKnb56h6DSvFgsH
 xCa4s1DGnZGSAtedj8E3ACOsEfu4J/WqXEmvMYNBdGos2YAc+g0hjuOB10BSD98d38xP1vPc
 qNrztIF+TODAl1dNwU4rCSdGQymsrMVFuXnHMH4G+dHvMAwWauzDbnILHAGFyJtfxVefABEB
 AAHCwWUEGAEIAA8FAltq9eICGwwFCRLMAwAACgkQ2B/JSzCwrEU3Rg//eFWHXqTQ5CKw4KrX
 kTFxdXnYKJ5zZB0EzqU6m/FAV7snmygFLbOXYlcMW2Fh306ivj9NKJrlOaPbUzzyDf8dtDAg
 nSbH156oNJ9NHkz0mrxFMpJA2E5AUemOFx57PUYt93pR2B7bF2zGua4gMC+vorDQZjX9kvrL
 Kbenh3boFOe1tUaiRRvEltVFLOg+b+CMkKVbLIQe/HkyKJH5MFiHAF7QxnPHaxyO7QbWaUmF
 6BHVujxAGvNgkrYJb6dpiNNZSFNRodaSToU5oM+z1dCrNNtN3u4R7AYr6DDIDxoSzR4k0ZaG
 uSeqh4xxQCD7vLT3JdZDyhYUJgy9mvSXdkXGdBIhVmeLch2gaWNf5UOutVJwdPbIaUDRjVoV
 Iw6qjKq+mnK3ttuxW5Aeg9Y1OuKEvCVu+U/iEEJxx1JRmVAYq848YqtVPY9DkZdBT4E9dHqO
 n8lr+XPVyMN6SBXkaR5tB6zSkSDrIw+9uv1LN7QIri43fLqhM950ltlveROEdLL1bI30lYO5
 J07KmxgOjrvY8X9WOC3O0k/nFpBbbsM4zUrmF6F5wIYO99xafQOlfpUnVtbo3GnBR2LIcPYj
 SyY3dW28JXo2cftxIOr1edJ+fhcRqYRrPzJrQBZcE2GZjRO8tz6IOMAsc+WMtVfj5grgVHCu
 kK2E04Fb+Zk1eJvHYRc=
Message-ID: <91a59ee1-cca4-8d0c-4f86-388434eb5a39@ispras.ru>
Date:   Sat, 5 Feb 2022 14:40:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220204091914.688259001@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.02.2022 12:20, Greg Kroah-Hartman wrote:
> From: Maxime Ripard <maxime@cerno.tech>
> 
> Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.
> 
> The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
> hdmi: Split the CEC disable / enable functions in two")) that
> (rightfully) didn't reach stable.
> 
> However, probably because the context changed, when the patch was
> applied to stable the pm_runtime_put called got moved to the end of the
> vc4_hdmi_cec_adap_enable function (that would have become
> vc4_hdmi_cec_disable with the rework) to vc4_hdmi_cec_init.
> 
> This means that at probe time, we now drop our reference to the clocks
> and power domains and thus end up with a CPU hang when the CPU tries to
> access registers.
> 
> The call to pm_runtime_resume_and_get() is also problematic since the
> .adap_enable CEC hook is called both to enable and to disable the
> controller. That means that we'll now call pm_runtime_resume_and_get()
> at disable time as well, messing with the reference counting.
> 
> The behaviour we should have though would be to have
> pm_runtime_resume_and_get() called when the CEC controller is enabled,
> and pm_runtime_put when it's disabled.
> 
> We need to move things around a bit to behave that way, but it aligns
> stable with upstream.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: <stable@vger.kernel.org> # 5.15.x
> Cc: <stable@vger.kernel.org> # 5.16.x
> Reported-by: Michael Stapelberg <michael+drm@stapelberg.ch>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/vc4/vc4_hdmi.c |   27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> @@ -1402,18 +1402,18 @@ static int vc4_hdmi_cec_adap_enable(stru
>  	u32 val;
>  	int ret;
>  
> -	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> -	if (ret)
> -		return ret;
> -
> -	val = HDMI_READ(HDMI_CEC_CNTRL_5);
> -	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> -		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> -		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> -	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> -	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> -
>  	if (enable) {
> +		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> +		if (ret)
> +			return ret;
> +
> +		val = HDMI_READ(HDMI_CEC_CNTRL_5);
> +		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> +			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> +			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> +		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> +			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> +
>  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
>  			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
>  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
> @@ -1439,7 +1439,10 @@ static int vc4_hdmi_cec_adap_enable(stru
>  		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
>  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
>  			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> +
> +		pm_runtime_put(&vc4_hdmi->pdev->dev);
>  	}
> +
>  	return 0;
>  }
>  
> @@ -1531,8 +1534,6 @@ static int vc4_hdmi_cec_init(struct vc4_
>  	if (ret < 0)
>  		goto err_delete_cec_adap;
>  
> -	pm_runtime_put(&vc4_hdmi->pdev->dev);
> -
>  	return 0;
>  
>  err_delete_cec_adap:
> 
> 

The patch has moved initialization of val local variable into if
(enable) branch. But the variable is used in in the else branch as well.
As a result we write of its initialized value here:

    HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
         VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);

Found by Linux Verification Center (linuxtesting.org) with SVACE.

static
int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
{
  struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
  /* clock period in microseconds */
  const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
  u32 val;
  int ret;

  if (enable) {
    ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
    if (ret)
      return ret;

    val = HDMI_READ(HDMI_CEC_CNTRL_5);
    .....

  } else {
    HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
    HDMI_WRITE(HDMI_CEC_CNTRL_5, val |  <------------------ UNINIT VALUE
         VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);

    pm_runtime_put(&vc4_hdmi->pdev->dev);
  }

  return 0;
}


--
Best regards,
Alexey Khoroshilov
Linux Verification Center, ISPRAS
