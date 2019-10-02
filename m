Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2396CC89E0
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 15:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfJBNh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 09:37:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36146 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfJBNh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 09:37:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so10350794pfr.3;
        Wed, 02 Oct 2019 06:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HlBfpevnrx8OkU72Yz9nwxL67zSz8/wbxqvT9WDZWyM=;
        b=ELn3CHBm9ciYZW/JElZa4Q5BFKjJVYZ2uyEyNlN7nFHdkjo3VhhXpheuZSE0jiFkww
         R3nDZm4hbGzkH65cP3z9shHyCf2MKk5nj1toc8rOzNgcPsfXhfZdkHoeGwoVkLginwsk
         /tmxDl/oaVxyJtflgm1/HTpamKOVGDAKF0bjwyjPXinQSyR9egBwX/viayN12PUs1jZb
         HR6OB1bvk/iZbzsGLSedt4mlyIk5CMG3XWmURRHl2v/lwFQxr5m0BV3JQ5B+H9yDTuym
         Nw/hprTzNjieMhisq/Agaen7WGPD8XU4ijwLUYLbbUzOL8VWY0UU2lCrYyOsbO4gt0FH
         BVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=HlBfpevnrx8OkU72Yz9nwxL67zSz8/wbxqvT9WDZWyM=;
        b=Hs1BPwhup7ZMmw7fi8D2cKuWYN3E1jLqaKjGUUwQN9mJsth72G2iDFulLPSCy5V7BA
         zzSA3nbc790CkcuWtE3A/Y7lc0QJRFwAyCDps1G4DcJEH1TW0A3o+Fdsz7O6KSUqsOzs
         gNlHK+nlwTHgOmIzNyzapMEluvKyaxkuXdTX+4cmTYrkH2pDaWrfa70aNqqtd9SeuelR
         LIeMZXt7v/ezVYrwIinyPNLgqs597/EhEIkHuAkb0Ie4CT+TbO67IML4hkM/yVvjR3Se
         Zlk/+0oW0vtNBcjVS0mBT+LstupZhbie75EE03uM69RQiTV6WzKmfBrKUc/RiEy7fb2O
         Eeeg==
X-Gm-Message-State: APjAAAWhDg8ghbsvECkjJUGCYJQ7moxKoMqdhYdz57TpFHipcZGztv4g
        mOeQ/i1q4XOqSM38rwv57/lhq8nT
X-Google-Smtp-Source: APXvYqyLa4D/aEOeS0o62oPtiNDLVsFlxKiXn4VBcyMhTS3oY2zHzntOcIoy52+eCv8LApT7NNK9ag==
X-Received: by 2002:aa7:9196:: with SMTP id x22mr4596504pfa.150.1570023448525;
        Wed, 02 Oct 2019 06:37:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m2sm23805830pff.154.2019.10.02.06.37.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Oct 2019 06:37:28 -0700 (PDT)
Date:   Wed, 2 Oct 2019 06:37:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>
Cc:     linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] hwmon: Fix HWMON_P_MIN_ALARM mask
Message-ID: <20191002133727.GA15583@roeck-us.net>
References: <20190924124945.491326-1-nuno.sa@analog.com>
 <20190924124945.491326-2-nuno.sa@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190924124945.491326-2-nuno.sa@analog.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 24, 2019 at 02:49:43PM +0200, Nuno Sá wrote:
> Both HWMON_P_MIN_ALARM and HWMON_P_MAX_ALARM were using
> BIT(hwmon_power_max_alarm).
> 
> Fixes: aa7f29b07c870 ("hwmon: Add support for power min, lcrit, min_alarm and lcrit_alarm")
> CC: <stable@vger.kernel.org>
> Signed-off-by: Nuno Sá <nuno.sa@analog.com>

Applied.

Thanks,
Guenter

> ---
>  include/linux/hwmon.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index 04c36b7a61dd..72579168189d 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -235,7 +235,7 @@ enum hwmon_power_attributes {
>  #define HWMON_P_LABEL			BIT(hwmon_power_label)
>  #define HWMON_P_ALARM			BIT(hwmon_power_alarm)
>  #define HWMON_P_CAP_ALARM		BIT(hwmon_power_cap_alarm)
> -#define HWMON_P_MIN_ALARM		BIT(hwmon_power_max_alarm)
> +#define HWMON_P_MIN_ALARM		BIT(hwmon_power_min_alarm)
>  #define HWMON_P_MAX_ALARM		BIT(hwmon_power_max_alarm)
>  #define HWMON_P_LCRIT_ALARM		BIT(hwmon_power_lcrit_alarm)
>  #define HWMON_P_CRIT_ALARM		BIT(hwmon_power_crit_alarm)
