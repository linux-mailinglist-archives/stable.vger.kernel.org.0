Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E696FA813
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 05:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfKME1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 23:27:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43928 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfKME1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 23:27:44 -0500
Received: by mail-pf1-f193.google.com with SMTP id 3so711268pfb.10;
        Tue, 12 Nov 2019 20:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=eimBgjDjKpO/BNiwKmZxZNq9wEIZnLGA/lSG4Kux51U=;
        b=J8+sF7LLJD7hfCpF/jBZUs+57aECYdff+iIP/LuncGv6kPW9iItkRCaAcpA/mQvtSw
         V9iWugGdF4NgSC7cmjdwNRPFEduGVEzPHqMhW/BA49ttwFANauw8PhY5VpbaWdRjrvDJ
         Q3ahozGpeLp1dIk5i9/MmagYp/kYYTjvR7RE1pvgCdu+52OtVRVf3CzNb1VVjF3qleJ6
         Rf1vQ7Ru9IIMPKZox+Tudz8zIFZ145x9m/fVxmmuEIrSW8P4XiV2xhcPZqh19Upl0Zcf
         NBJLvhx9p9mnx5MirkRvncZvSYAqJ+YMF9aFHz6xUDH1k7D3VaPqRdeJqTnYXvTklaRP
         SMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=eimBgjDjKpO/BNiwKmZxZNq9wEIZnLGA/lSG4Kux51U=;
        b=qdsTLm4N3kiXmcDvDB24MAEL5aMhcUQDiaU/FJUcSOtDZcioOXjoaDkWxBSBEH21rL
         LDctBSEq9AgyfHGMWGvslQQfCOtkKAcBJzWidl8D4LFSER2KZDKiIjcUJvZOyUNR4FDA
         u0pN0UZ1zRIwkTGE7Al9OoWX5yptWPhc78bElJn4BEO7NKSWTns5FBJ+OmcZCUnNbYJJ
         +wcmesTyFFNO/R/u0aJMjCKOXbW6GW1repkNFxBBNWA1jUeFjoBKeOZwkUvJkFpluGv6
         zkuKTye26xtqIDRbKdLKS6hxuH3qp+U1byQHLEU/qVIKQiIqFb2coMSTPtpe1sXZkLKz
         f0Dw==
X-Gm-Message-State: APjAAAV+1V6EHvJDD34OGUuh60nXrv3W3L0HV23XH9EJcNT34MHdOMMX
        MD4s7gZibxmdzln//Qa9dbZFFdcR
X-Google-Smtp-Source: APXvYqyYBCllFsmBxPUEeJvCjXUpQTItrGDDjxuQ9C1v8WakRhhFjt559UgpozFGs7XIwQxfJyi8Tg==
X-Received: by 2002:a62:8789:: with SMTP id i131mr1786390pfe.221.1573619263465;
        Tue, 12 Nov 2019 20:27:43 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id z11sm664741pfg.117.2019.11.12.20.27.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 20:27:42 -0800 (PST)
Subject: Re: Please consider mainline commit 9393c8de628c for stable
To:     Sasha Levin <sashal@kernel.org>
References: <3bb75710-9e53-4896-b368-a3c5a3fc7fa8@gmail.com>
 <20191113012739.GN8496@sasha-vm>
Cc:     stable@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <a7ccad7a-01b1-4cc5-f9a3-c08bb160a351@gmail.com>
Date:   Wed, 13 Nov 2019 17:27:37 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20191113012739.GN8496@sasha-vm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Am 13.11.2019 um 14:27 schrieb Sasha Levin:
> On Tue, Nov 12, 2019 at 03:52:47PM +1300, Michael Schmitz wrote:
>> Dear stable kernel maintainers,
>>
>> please consider including commit 9393c8de628c ("scsi: core: Handle
>> drivers which set sg_tablesize to zero") for inclusion in stable.
>>
>> The commit fixes a long standing bug that affects all SCSI low-level
>> drivers setting sg_tablesize to zero, introduced in commit d285203c
>> ("scsi: add support for a blk-mq based I/O path.") around kernel
>> version 3.16.
>>
>> Use of the option use_blk_mq=y in kernel versions prior to 5.1, and
>> any use of such drivers in later kernels, will result in a null
>> pointer dereference from the block layer.
>>
>> I hadn't expected Martin Petersen to pick my fix over another one
>> submitted by Finn Thain, so I never added CC: or Fixes: tags.
>
> Could you provide a backport for 4.19 and older?
>
> We would need to work around not having 3dccdf53c2f3 ("scsi: core: avoid
> preallocating big SGL for data") in older kernels, and I'm not confident
> about what I ended up as a backport without ability to test it.

I hadn't spotted that. From  what I've seen, that commit renamed 
scsi_mq_inline_sgl_size() by scsi_mq_sgl_size() (among all the other 
changes) so modifying my patch with that in mind should suffice.

For safety, I'll test that version though.

Cheers,

	Michael

