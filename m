Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF3511299
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbfEBFaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 01:30:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39140 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfEBFaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 01:30:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id e92so498173plb.6;
        Wed, 01 May 2019 22:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bgtS//bbkUutn48shN8ik/QfEzSXOukAyQ9VBZFnVr8=;
        b=Zg7jVyLMrwv9oxHIkcOzRyxejGDqonA1XD5cJBkLzOCZMT9L8PaYE/q8whrjhQzs11
         Ae987aDWJq5+jm3OOJ6FymO6TnNXiSe7VxVlnWvXy51lSpDKvaPQTYGiH7dftpxgha7o
         ug18cVYPTM0rQwCTC6BFFm8QWFaCRre0C7EeAcghTJ2yeAdIKA7dNuRpTgOs0dz9M2Aa
         eMxR1XvQ0r/f3SQ3wcAie8BJCXoqIBGzJh71GJKR10qMHnjdTpREXzBGUCWgXuDjDx0S
         Shrg27W5CBO9KeZiGs9icWjmqStlHlPCY6SiOZw6SXs/9mkbkVGlFnVEBd0ySKw7gwDu
         ZFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bgtS//bbkUutn48shN8ik/QfEzSXOukAyQ9VBZFnVr8=;
        b=KHa+bduKaNb4ZN2uZ3UeSvY0tyoC1bRI7IO723edTenCoHzqNza/rSZlyJGX1ObD+K
         wjY+yHc0zLmcwDkyWnLJg474pQOnx8YvUC6mvQL0PuHdVhHdgx2PApLLezg4Gwx0ubH0
         pNVCABu243LJlw1O6ggfhAc+ybcdSUoKx0FqH8NssW3MIHoRXbxWAUnkdF8IAigcPnHt
         BtMLTHzqmSilipE+FddmEl/fRaRwP//TIcmsZmRWJhkn/PCPi3yYC6vzYCIIX5GjE3/X
         sMZpo5M6qR2CwYGz68px8ev/UYoCNoGeh0G+nrDYHvM2rImP1o7fWaO3rdDRjeKdH2n+
         vaTg==
X-Gm-Message-State: APjAAAWNuD29jf4+zTSg8VGFTrnwmxX2Rgl2CLzojtT06iGmHlmTXPDi
        aX2fs57hFpYJPrwZSYp9xXc=
X-Google-Smtp-Source: APXvYqwcRWC0buOcrS8fLi/yEQiaVIoX98kqzYbmUZk0s8NJ7o1V9ds7d7Yknt01+XdIAarKoxyJzw==
X-Received: by 2002:a17:902:2a2b:: with SMTP id i40mr1668104plb.170.1556775015214;
        Wed, 01 May 2019 22:30:15 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.31])
        by smtp.gmail.com with ESMTPSA id g128sm11108892pfb.131.2019.05.01.22.30.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 22:30:14 -0700 (PDT)
Date:   Thu, 2 May 2019 11:00:05 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
Message-ID: <20190502053005.GA419@bharath12345-Inspiron-5559>
References: <20190430113608.616903219@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86 machine with defconfig. No dmesg regressions.

Thank you
Bharath
