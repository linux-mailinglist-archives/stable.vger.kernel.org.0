Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C450E4970AF
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 10:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiAWJQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 04:16:50 -0500
Received: from mail-ej1-f46.google.com ([209.85.218.46]:46595 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiAWJQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 04:16:50 -0500
Received: by mail-ej1-f46.google.com with SMTP id o12so12820588eju.13
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 01:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=4Fk94yxufk7k/KH/gvcuKWpl8L+xURnatW13fsi5eGEpu58e9fgMzMy72pXIX8E3S9
         ZpJuEFAJaIJQkXXSzq/kDkSO+KBh1vKC3oAS6ySKitKGE6pZuLGwYXDDlPjygnTEE+c3
         TGCxwimPfZJ3sTnIgVUTek+mJ1YWvcnTfoVyYTpymUhpLbtB6l6ypa42d/+mHBMDwcAV
         6J2Jp4J/lcByC1aQMhE6iBZHE/nH93iHNnxU0sUuaBOWi23n7gQca7rMRGSyoZkZ1sJk
         BGZ1ntOWkgM30HDzbpUoMtjlm/SmnD0hXupAebC2JM3gX36obn4sEa8gaN0QM54vudCl
         cfPg==
X-Gm-Message-State: AOAM532paAIndibWLE5bazGO62doiejNqk0vtRs0b42L0uzoU+8bvV6y
        yuD2krPMZn4rdbhvQ0lC8GMkMebbP/o=
X-Google-Smtp-Source: ABdhPJzzz64xB41wXO5XOv3+AhbkqC8wUkUjAnMooki4uJHZwQblD09K+vnMhGWNvMU/Nvj1ZXzVJg==
X-Received: by 2002:a17:906:fcc6:: with SMTP id qx6mr8406229ejb.183.1642929400032;
        Sun, 23 Jan 2022 01:16:40 -0800 (PST)
Received: from [10.100.102.14] (46-117-116-119.bb.netvision.net.il. [46.117.116.119])
        by smtp.gmail.com with ESMTPSA id gr7sm3640820ejb.2.2022.01.23.01.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 01:16:39 -0800 (PST)
Subject: Re: [PATCH] nvme-fabrics: Fix state check in
 nvmf_ctlr_matches_baseopts()
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>
References: <20220120201737.65390-1-jsmart2021@gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <9484b632-c41d-04bc-364f-9df1c2e1ed95@grimberg.me>
Date:   Sun, 23 Jan 2022 11:16:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220120201737.65390-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
