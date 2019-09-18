Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E336B6D49
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 22:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390759AbfIRUKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 16:10:07 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:39716 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390755AbfIRUKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 16:10:07 -0400
Received: by mail-pg1-f175.google.com with SMTP id u17so478310pgi.6;
        Wed, 18 Sep 2019 13:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jejDW17MGpVNFAQ5/vkCZ4/il8VDfaKN7ZaKNxusXrw=;
        b=n3vWxfgZ8SeYyOww2zluzjHrNIao5GU7t3m2jJbg2yHpUE07vvT0OxuDCGSj2pQ+KL
         3seYqcOOd/ifrzWL6vJTniQ/F9MgkNsTwoXAfXC8elrwO6J5u3L7x70vz5OLIZD+CQ3P
         YKsTVNeKHzMd4F2gdVoBXMPtuxzER5IPkxL/KRmcgkcfQKJBLTDFV/xglME5RwcczQJz
         Enif5K9vCL+FSld8FXrHIp8KvXOgpZXSruw5K1q8vSJmnSEZ5+dhczg8drdy6Y9UqbQR
         5qfPb6iubps0rZTDp6/UwBPIJFiKq/d1PeWBkbCTMW2EP8fdGLScZyWPHTbzJneB1lqs
         gdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jejDW17MGpVNFAQ5/vkCZ4/il8VDfaKN7ZaKNxusXrw=;
        b=Kza4mF2ueE7bMfELHNfjN8H8o56DpYTZ6nKVPwHcMvXtVNo4OgKCsY3ExrFSDpl6+A
         DGZNBm7PuMEELGWkbEfTo+V72yacyAwg5I/GhStgu8QhfKRz3zDQTVxFvYD/WM5EJChi
         W0gtrfg2Ejgzu71YdfbxPzukUTY/I+Oe2KTk/aEoDDb9sZWauB/cNpgRyGhBE8QM6tUM
         ZrbhpDA1dWCJFR3oFnmfOD5Bysfhw7cD2jA8BHJCmBtEVDBhVipy9NiGZ75Ndj+q+ScA
         Kh3m4BFajQHzjJDAvc+PQrGKYfnog4i5yils8SZ3TizhElpN1Qe4Cv8nhf1IURwlviDT
         buCg==
X-Gm-Message-State: APjAAAWUr9a45905r7jrPVyKjB6t6B3I7ZM7ciiIUqUDCszGJePKaj+l
        MokVSOjntqxsw+o+wRJJLNQQPN5uzxyFbg==
X-Google-Smtp-Source: APXvYqzTQvgTSnTnlTjE3UXi08rxjA75davJqgX8Q7HCdmsihlqcdgP6FYWFJw8H2mY7NGYnEpqHuA==
X-Received: by 2002:a17:90a:be13:: with SMTP id a19mr99793pjs.55.1568837406331;
        Wed, 18 Sep 2019 13:10:06 -0700 (PDT)
Received: from [192.168.111.105] ([198.182.47.47])
        by smtp.gmail.com with ESMTPSA id v44sm16028192pgn.17.2019.09.18.13.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:10:05 -0700 (PDT)
Subject: Re: stable backport for dc8635b78cd8669
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <lkp@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        arcml <linux-snps-arc@lists.infradead.org>
References: <efb68643-3750-e94b-8387-6e4cacb3a82a@gmail.com>
 <20190918185633.GB1944551@kroah.com>
From:   Vineet Gupta <vineetg76@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=vineetg76@gmail.com; prefer-encrypt=mutual; keydata=
 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
 deE0Dvw98SWmZSNtdOPnJZ0D
Message-ID: <6bcb935a-4dae-48cc-ad1e-88a51b9d6a5c@gmail.com>
Date:   Wed, 18 Sep 2019 13:10:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918185633.GB1944551@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/18/19 11:56 AM, Greg Kroah-Hartman wrote:
> So is this only needed in 4.9.y and 4.4.y?

Yes indeed !

Thx,
-Vineet
