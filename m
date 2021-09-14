Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22C440B09B
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhINO3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 10:29:41 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:34815 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhINO3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 10:29:40 -0400
Received: by mail-ed1-f43.google.com with SMTP id i6so20221122edu.1
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 07:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kicEnr2Cugeg1q66CI/wvoiBYIFJN2vXcDbJaUW4tr0=;
        b=fWRViz32OoFe5JVF+76PU+nDLAaBT0Ox76+aKcUF9RnWJrH0i9VMCp7q1DyqTYII+s
         xOuY06CQBLihbcPAjULDZJSTt8bTc1inEdbD9VVioRixKEmK9Vp5cjroxW8z5ub35ncz
         M8N8weTvnJn3BMelsaFHDG5azpRNomAWGH9VbvZ2CV/qRolNMjyhPbUDHkfCHW7SNGnx
         ivN3qdztstlgcpYqGEQIsWantvQuG9vudXfvaAwx0wuMre1qoUgNLFWdjYMo2lfqMYbR
         TB4eT4SuCndBeJmvfFa+ybyxnKiULQMYhEpZhlmvRqekESyZZO2Mx0lsrbywlCc5JWC0
         BTXw==
X-Gm-Message-State: AOAM532Bke+rGPKbar17JnSEKMLZ6lNrcqcJUd7LLPxnangJuN+FVMiA
        Gx/Ec5goWhFWNECHaN/WyBg9wwxFTZo=
X-Google-Smtp-Source: ABdhPJx/TtwjqUpck2gI5RgHPPw6P8avek2CfZ1CWFvY/bPMA1mWlaDBKIKo2V5dnfBmLBqhcPI+wA==
X-Received: by 2002:a05:6402:150a:: with SMTP id f10mr19579705edw.318.1631629701787;
        Tue, 14 Sep 2021 07:28:21 -0700 (PDT)
Received: from [10.100.102.14] (109-186-240-23.bb.netvision.net.il. [109.186.240.23])
        by smtp.gmail.com with ESMTPSA id bt24sm5011798ejb.77.2021.09.14.07.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:28:20 -0700 (PDT)
Subject: Re: [bug report] nvme0n1 node still exists after blktests
 nvme-tcp/014 on 5.13.16-rc1
To:     Yi Zhang <yi.zhang@redhat.com>, Hannes Reinecke <hare@suse.de>,
        linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ca405578-5462-0ab9-91ab-de9d42ee0570@grimberg.me>
Date:   Tue, 14 Sep 2021 17:28:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHj4cs94pDUfSSfij=ENQxL-2PaGrHJSnhn_mHTC+hqSvPzBTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Hello
> I found this failure on stable 5.13.16-rc1[1] and cannot reproduce it
> on 5.14, seems we are missing commit[2] on 5.13.y, could anyone help
> check it?

Was it picked up and didn't apply correctly?
