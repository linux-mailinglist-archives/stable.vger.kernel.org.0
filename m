Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F63F40D75C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 12:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbhIPK2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 06:28:00 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:40320
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236387AbhIPK17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 06:27:59 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E4D0B3FDC7
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 10:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631787998;
        bh=6S5AMhCNVrlspN/3bjYdeLfuwtE9nTG661txhmEAamc=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=jdVf2kKPfNvog9XGy1qS+JnSgmqepI47liE/8I+qzTOd4pbJwI0PRtRrH+Q7IcEl3
         Q1bqkfMczZEXxPVfRHEjk6zcbSM2vW0qDFQ++rhNjJNPrOimCGlaDct8VnAPK2HyO8
         PhXEaBy0THc/U+8jnNyHTyjFYtoLOfKjqnTYRc4Mu4+vSXYVJAlT3W+a+hVOAYnYRL
         5vea2+BCPfVUVnnmiZYGIarqVk2HoAjJIOXZzhkuqoCiPC7NHBhqAh7nw0M0XCb0/r
         PoZL9aLzOA+7anVGhL4U6Oq1wus0vDXEhNyWuXn9DMByq6TAEw+x1foHAJsDRonJxa
         ChGFRYD70TItw==
Received: by mail-ed1-f69.google.com with SMTP id z6-20020a50cd06000000b003d2c2e38f1fso4912038edi.1
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 03:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6S5AMhCNVrlspN/3bjYdeLfuwtE9nTG661txhmEAamc=;
        b=qSAk3IGAlwa4U7Tad+N/6jWj7c71TSUhW+CyDxQh0dsMJfUkQUF8sn+m+fu6qNNUgl
         XTGjeF2LBS5eQDiTK8UZPYmxKiP0nU51nIve8QtMWe85dOUCbJgqWDpYac25qVh+Cjhi
         7zZqXe/syP93a+lmqTNVj40P8pdNMb4q2EAcuRTPUNHFfVDBuS1imVsglA5diZszaDQM
         HHvFWfDXyCeWLH8i58+w0N6M6umLK/l74iUIf0ySPd6UQIgURftD5kwetFOB04YbkFfX
         VabNuaiHwv/rrbY7MaE0oenSJsem5qtlQL2IUMK/xGvIEsJu8l4ZzsR9WCQB52EayYO1
         mj9Q==
X-Gm-Message-State: AOAM5322qVGtVpKc4uy4GVBDDShKYGO7SzOSKAm9n9fRoWYfGu1TTIzq
        vDl/gxYhk27dFd3C5kGinDkyub+bfx45aPCf5VXCru+pV/deylQ5qvAtUZ+bGj/+fNVs2Jy0YWC
        3oVQvY9yRIM37D4vmBVvWT9Y9MuJ5FpF9Hw==
X-Received: by 2002:a05:6402:4cd:: with SMTP id n13mr5650689edw.215.1631787998092;
        Thu, 16 Sep 2021 03:26:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfSeMhkwPLYCWP2Bv59mSbK2nZi0Xj85qeOtzME5EdliawbHvYnmlDnqnvoh8tL8BfQ4m2Bw==
X-Received: by 2002:a05:6402:4cd:: with SMTP id n13mr5650680edw.215.1631787997971;
        Thu, 16 Sep 2021 03:26:37 -0700 (PDT)
Received: from [192.168.3.211] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id v12sm1224424ede.16.2021.09.16.03.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 03:26:36 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] power: supply: max17042_battery: Prevent int
 underflow in set_soc_threshold
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>, kernel@puri.sm,
        stable@vger.kernel.org
References: <20210914121806.1301131-1-sebastian.krzyszkowiak@puri.sm>
 <20210914121806.1301131-2-sebastian.krzyszkowiak@puri.sm>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <eb0d1829-2379-c0ee-4043-70c86203286d@canonical.com>
Date:   Thu, 16 Sep 2021 12:26:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914121806.1301131-2-sebastian.krzyszkowiak@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/09/2021 14:18, Sebastian Krzyszkowiak wrote:
> max17042_set_soc_threshold gets called with offset set to 1, which means
> that minimum threshold value would underflow once SOC got down to 0,
> causing invalid alerts from the gauge.
> 
> Fixes: e5f3872d2044 ("max17042: Add support for signalling change in SOC")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
> v2: added commit description
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
