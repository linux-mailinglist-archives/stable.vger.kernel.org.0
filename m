Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5FB3D9396
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhG1QuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhG1QuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 12:50:10 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945E2C061757;
        Wed, 28 Jul 2021 09:50:07 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id p38so1850367qvp.11;
        Wed, 28 Jul 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aPvn03dAVrSIGHF0vDfcg0ZwegQjrgk0lzNmIB7gqhc=;
        b=Z15G+sZ+Id3MPBE2DDKw9NHWia3RdHXvH3ppJ4osiJ/obAqLXRAnWDjidptDCgAXf9
         xyyiFZrOPuqEsrSNcZK1tLK4GIPx3kJCxnDhXB4ULvE4aJLU2VpqyBffRAx3a+V5QrWN
         w3AOlOoSqEfPdSXCC9JLNPeRS6J/VbFyIddHfL0kOn/T60HpvNBYSjHhdfnSobLOtlff
         hu9p6MsZJ8GCX7MlNAwGSk48DD+7x4i84WOFXxMSvRwY6gzUf63GzMtdXi+v1lo/MbuG
         ZGXpTwHAgtGAykaH3dmZFOaJcYB/AENQAZwXwJ95sUTwtMEkfvtztl0D7lblTwAkUh2Q
         XiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aPvn03dAVrSIGHF0vDfcg0ZwegQjrgk0lzNmIB7gqhc=;
        b=rhtdsKblKTDhSatRVvj72pwFb+F8Md6e9GFqnxBNOjdk7wyexKGcFjgLbzdRfpH9HA
         xICSoNCAvPnWm0QsnO+boF56D5ht9hoSTlPzuiIqJny3IlI5L7gEuA7+8Cci6jeQaHAu
         DgWU2FjpxO64uKHHZVhIfTHml6aYnTANQ1iaouPRHmohYN1qzfAr5prlpIQVlZLMZ+0t
         JNWpL0QlTvorZfieE1gUgUYkZqQ7IJA8jjgmpWuIaWTVXZcpcXbS8oa9p94hafkcVn1D
         kN5XRoutq2vV99uwrVD20l1ehPQxp3RBOUg9yM1n+xPtgXYl+pJeULVkH8p2c/aa2QAD
         r8Zw==
X-Gm-Message-State: AOAM533vLZ8fHQZicz4Lr/JS7mq5Eix5Io3OtagvCcc8d0b1H+yqTauB
        W7w3hgiYU6eEdbwkhYb+lhjfUJWMi/Z4Vg==
X-Google-Smtp-Source: ABdhPJyHHLF2+vd33EpApzkYUYUqWYYKTEmgQz96MjG4EoXIizqBzlkqzHlnqpGK6gRLx7onQbbb2A==
X-Received: by 2002:ad4:4f51:: with SMTP id eu17mr921935qvb.48.1627491006819;
        Wed, 28 Jul 2021 09:50:06 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id w19sm271555qkb.66.2021.07.28.09.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 09:50:06 -0700 (PDT)
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ
 override"
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     rafael@kernel.org, gregkh@linuxfoundation.org,
        hui.wang@canonical.com
Cc:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, manuelkrause@netscape.net
References: <20210728151958.15205-1-hui.wang@canonical.com>
 <YQGA4Kj2Imz44D3k@kroah.com>
 <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
Message-ID: <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
Date:   Wed, 28 Jul 2021 12:52:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/21 12:38 PM, Rafael J. Wysocki wrote:
> On Wed, Jul 28, 2021 at 6:08 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> Applied as 5.14-rc material, thanks!

ty!

Will this revert be auto-magically backported to earlier stable (5.12x/5.13x) trees?
Or does that require a manual trigger?
Or, is that a distro kernel release issue?

