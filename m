Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87E926E47D
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIQSug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:50:36 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39477 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQSub (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 14:50:31 -0400
Received: by mail-pj1-f67.google.com with SMTP id v14so1675596pjd.4
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 11:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1GhABgMF2nYcMEfinK1VkEI+9P2lNW72Ze1I0ct4uU8=;
        b=LUYAk+Tk+Ozt8lTcGOb0J+dQAf3S1ZG5GSTMePmCtn62LULZ38KleNauoRlIypJgTF
         NscwgBUhStSHsiQdc/pRB9m88DmU+v5osz04ePoN0BfuXyLfkQkpxWn5A5ahBDAarH4V
         ZzKsbEciVHDUFStsasS3EZ7aaVUPlEpuLzHwxxQz5XraFCCFfGfl0/mv5n6RwLV2qsZH
         hOS1p2CZEkwpwbYG7mqWB16VRpL/DDsgyLX0uoKunGOJ4Mi3Jnqqf2m0bKPh4eezIKwL
         6scXG8tn8r/o5eJImA2z1eGQu9SINbhZ3FEmD4woZYZ635WfpaEMlQMk6w/8QKEIQa1Y
         1OKQ==
X-Gm-Message-State: AOAM5300MvW6AZE5q9+jaV8Srt96JWYSzll9XBefYqd1nAZZUfzGW2Ag
        n0a+r8lmP/tcec0M+CF66TQ=
X-Google-Smtp-Source: ABdhPJyja4zeA1IwA2IeyAFLANI3Pq/v+5/jcT+J11TWsx057WpV7sCbVflvodzaZSb6ASOXspSxWg==
X-Received: by 2002:a17:90a:e609:: with SMTP id j9mr9089476pjy.129.1600368629557;
        Thu, 17 Sep 2020 11:50:29 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:97b9:ed87:f308:cadd? ([2601:647:4802:9070:97b9:ed87:f308:cadd])
        by smtp.gmail.com with ESMTPSA id i25sm374582pgi.9.2020.09.17.11.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:50:28 -0700 (PDT)
Subject: Re: Please apply commit "64d452b3560b nvme-loop: set ctrl state
 connecting after init" to 5.8.9+
To:     Greg KH <gregkh@linuxfoundation.org>,
        Yi Zhang <yi.zhang@redhat.com>
Cc:     stable@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        sashal@kernel.org
References: <16579579.1342431.1600270596173.JavaMail.zimbra@redhat.com>
 <1955465429.1342553.1600270677594.JavaMail.zimbra@redhat.com>
 <20200917143425.GF3941575@kroah.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <32a2f419-d29d-4835-3eb4-34c9b01191c1@grimberg.me>
Date:   Thu, 17 Sep 2020 11:50:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200917143425.GF3941575@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>> Hi,
>>
>> Please apply [1] to stable 5.8.9+, as it fixed nvme-loop connecting failure issue[2].
>>
>> [1]
>> 64d452b3560b nvme-loop: set ctrl state connecting after init
>>
>> [2]
>> https://lists.linaro.org/pipermail/linux-stable-mirror/2020-September/216482.html
> 
> So the "Fixes:" tag in the commit lies?
> 
> I would like to get an ack from the maintainers/developers on that patch
> before I queue it up.

Acked-by: Sagi Grimberg <sagi@grimberg.me>

This went in citing the wrong git hash, our mistake.

Actually, the cited offending commit had a fixes tag itself that
goes back further[1]... Which means that this needs to go with that,
what's the procedure to take this along with that one?

[1]:
73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
has:
Fixes: 35897b920c8a ("nvme-fabrics: fix and refine state checks in 
__nvmf_check_ready")
