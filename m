Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA243A147
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 20:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfFHSuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 14:50:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43508 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbfFHSuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 14:50:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so2972510pfg.10;
        Sat, 08 Jun 2019 11:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n1nTu8hWTwf9Vys06vQlXsu9bN0X8oY6YzR1lyX9LYs=;
        b=sfCgopj98DAEgR750e8izwO00TpHdnCQ4n9+nJOn4ij4OPxINbICfz3Ddb6arRzmls
         mQ3TazDaZ7XkZVS7eZIujvZSVyf6iEIKSOBN4zdNPNvdQHtEQ87p9zEdimHlyiqm5nFx
         hXbwaIza332ljNfNi8NZyTVObaPODxT8tMykYje58Lu0GEPCrvwAisPZjhnKwvuNhwTp
         pe7mORlXlUwo3NHhjFsL7s21UDvixW+TAOkNEk+fB2fyQKPEQlJlUiU0hhFT/IPkW+y7
         914VjF39igyjC7DIUKwoLW+ri5DugYQQmkLSBUNDqBhC7UWMO4/S7LLm1I1CJSJYIvi/
         AFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n1nTu8hWTwf9Vys06vQlXsu9bN0X8oY6YzR1lyX9LYs=;
        b=cWEW95lKahkRG/z419GDLECweRt+mNhG+YrgFtK9OQQSMcyjohSBvSmmpBixGfmT1c
         UoJzX6GtaMlD2oC/mCIqucoiG/BQ+bfdmPSacbXMsfzwPK0S0Sxp17xhNOEcFY3b3SQa
         wHUEp0eC5aKA/P/uWs+ThJCZmcczBssNPiYD6GnUJKIwikOdpp1oD/JmbsDbhywtr3ai
         abzq4M5hBkEcLEXR19J5Lu0E2dQr/A9zJ09kxTY1X8lw5rgnuiKIE6UTVTVAJLqFU9+j
         MmKZzARbOCh2Tvm58JvtkQsAzy2FHA1SZSiUH5cHRpg2/qaWc6nOc9nQGXApEfJtbAt5
         Dj6g==
X-Gm-Message-State: APjAAAWaWkVmaWXY6uJVaUdEIQWJJXAfrf2mNXPdEaNIDfp7BljOVjDT
        EQq2S+qZYiugqEiNGzKVD0FZTZaQ
X-Google-Smtp-Source: APXvYqxwAllbWTuON2mxkwShElyPdFqtr5Fm5+Rp8ind677guCe3jSkCMVda3hIvK75zC5MB1THIdw==
X-Received: by 2002:a63:4d05:: with SMTP id a5mr7915237pgb.19.1560019799363;
        Sat, 08 Jun 2019 11:49:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j20sm6294033pff.183.2019.06.08.11.49.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 11:49:58 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/73] 4.19.49-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190607153848.669070800@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <87b959b5-29c4-a4d4-575b-e2517082a1be@roeck-us.net>
Date:   Sat, 8 Jun 2019 11:49:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/7/19 8:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.49 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 09 Jun 2019 03:37:11 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail:

Guenter
