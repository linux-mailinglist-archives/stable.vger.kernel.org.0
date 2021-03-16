Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7E33D8F0
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 17:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbhCPQRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 12:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbhCPQRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 12:17:37 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79156C06174A
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 09:17:37 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id z9so13217884iln.1
        for <stable@vger.kernel.org>; Tue, 16 Mar 2021 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MEwQloA6Sbs6wcbrOL1SorV9LxqSXhkO7dOkdPzni08=;
        b=ZTeCpjDkkjUsieQCpDnZ/P0+EqQ3uvpnbNQc/IxLxVVMPJ2yQ0JkppWLH7fY63FRJZ
         EVe3q5ENwDpKyDQspAm3fY3v1myd4qUA9CCEWJgbO8ex1EoWiElphFWFilMCqd18UZOi
         YXGOSqscz1rvElHxQ1ViIB9c5x7DolyFJebsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MEwQloA6Sbs6wcbrOL1SorV9LxqSXhkO7dOkdPzni08=;
        b=j8CKA5y5DhFztpzrMF+MjXVsu3yV1AL3ya8Kzc41D6LvQ2terME+fUAK5+OOoeEeJJ
         ry4UQdDKZ2TDBlguIxJ+haNYwyNEZ41TrrxBG7tuAWtd01+d2W8wm37lZnU0HuxDOkO+
         DSzcSTKik+wkpyOzp5wwt5RBPPfvUzM7VlP5l/0mPGANRMbOb2ooGM+1fo3D3+x8pgzk
         LqF8kCZuUX/Ym/12nTrHEl0jSNYxbRVm8h3Cii/mvI//ibE5vm2W+Zw94KNZrmgtfLB0
         kzszAoBNgj4SqUhXTNhqoEgE/CqC5ievb6FQx9O/YIT6GjM889q+xfPodZdw5S9JvgLX
         vhHQ==
X-Gm-Message-State: AOAM533Id/vwI9dkCm5kMVAsmQueWgHMIw/glQXQWdS3AwYeS6E6wjye
        7osuzsv5sO6vM775YSkgKhCPOQ==
X-Google-Smtp-Source: ABdhPJxL+rYdG4+7zu2ISFBDBSQYDvJKYeWqVVP7yBu9VsFtuFXVy5l+neqtJIchvaWTzQkiOYi8Sg==
X-Received: by 2002:a92:d6cf:: with SMTP id z15mr4368628ilp.40.1615911456994;
        Tue, 16 Mar 2021 09:17:36 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b20sm8725500iod.22.2021.03.16.09.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 09:17:36 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] usbip: fix vudc to check for stream
 socket" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, penguin-kernel@I-love.SAKURA.ne.jp
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <16157245893852@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <aa6c5898-f783-e1ce-a32b-9b3601dc856b@linuxfoundation.org>
Date:   Tue, 16 Mar 2021 10:17:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <16157245893852@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/14/21 6:23 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

Thanks. I will back-port this series for 4.4.

thanks,
-- Shuah

