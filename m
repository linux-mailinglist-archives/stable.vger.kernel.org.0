Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BD4A0046
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343613AbiA1Sm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 13:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiA1Smz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 13:42:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40991C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 10:42:55 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id h7so19004990ejf.1
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 10:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=BdAVUo9jTeaXUKpBH+a+0gFDzqrn0mNTlBbAlAq9XM4=;
        b=OBTsZorFhfVUvOSjpS0QbA5buxxdUlL+ZdDzKAoO6coVhoCB+FMoCue0iiWcc0Gp22
         5ZWxpyGU+6Kzgt+j/qXDDX+cmwKdRKtL3bAwHzlE+G8GXeXhoXWHQRzWPDZ4RSVOclzH
         okhPOxrFAIF8WcNJryWcw0ACvFQoZpBXQx7t0c4icmwrL8ah6YorHxNgUqcmF3vvnhtf
         RCoYoePl+E3GfrfVcgyA1G+fNbzqzxZErD0JW+jYNCiIoD1A+rfkBqkUe0shYk0430n2
         0bVhEOuUX5th7ZE6guzYEn+qLQJ6JOpqbOMi8EDwYWbdnFWBpHc5GbJSOVyRecAhKFF5
         0DrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=BdAVUo9jTeaXUKpBH+a+0gFDzqrn0mNTlBbAlAq9XM4=;
        b=iN9kQK6YO3r0u/JTvANZT1A8nR7WSO998s8nJKBNZ8lVg17+z77/U4Vb9YLYcOC9ak
         sn2ONMna5JBWD3GrgQ+WO9XB5rzTuSovpdbrsSz7KxPDTzAW8+z1+F+scEkr19dFVWjy
         OVXZ/o6LYl49eEkDVoQvM0UEgB0j77k2HaXpPCl8zd+eWMoe7b0oRvwjA6iESt5weETf
         0F2yvNY6YXXn3//x6m740hxcQ6yGcFaCpnKdEJziqL7Sdjh1TnoCnbL/wiqnvkUZdT5r
         qBoI8bKuLj30ZZhV4/GKVKCO2/gvPZQ6Vf78gVA+0dNyxm1GOJU9nP72nIdahp1RBvWk
         evIg==
X-Gm-Message-State: AOAM532H38QPKuYxOuysJksTD2oZ018hdu02YtGvu8S6qmFrtc5PhUi2
        hPti+Z2eX9QrQ6DMxUpPSU/USF84tHDF3w==
X-Google-Smtp-Source: ABdhPJzXlPENbaJBzI0MZf0dFnUY7RWh+FKNFalAvyripwwRC24y2OnzdrNxt32bSI8OrXNYs1NHwA==
X-Received: by 2002:a17:906:f93:: with SMTP id q19mr7880084ejj.413.1643395373826;
        Fri, 28 Jan 2022 10:42:53 -0800 (PST)
Received: from ?IPV6:fd01:5ca1:ab1e:88c1:2f31:26d3:625d:98e4? ([2a09:bac0:20::81f:a350])
        by smtp.gmail.com with ESMTPSA id v14sm10355088ejy.77.2022.01.28.10.42.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 10:42:53 -0800 (PST)
Message-ID: <608b625e-9eb0-8320-c45c-e5671b44e58b@gmail.com>
Date:   Fri, 28 Jan 2022 19:42:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   syphyr <syphyr@gmail.com>
Subject: Bluetooth regression on 5.10.94 LTS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit causes a regression in Bluetooth by creating false 
positives for malicious data:

Bluetooth: stop proccessing malicious adv data

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.10.94&id=ffc9019bd991707701273c2e5d8aed472229fc4d


This commit fixes the issue above:

Bluetooth: refactor malicious adv data check

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.17-rc1&id=899663be5e75dc0174dc8bda0b5e6826edf0b29a


Please add to the stable release queue.


Best Regards.

