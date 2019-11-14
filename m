Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54ADFFC03E
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 07:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfKNGhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 01:37:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38192 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfKNGhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 01:37:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id c13so3469748pfp.5
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 22:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=8lQHQcNPbuMFQ0EQz27AnnoTfjTcciitO13KnmFwEu0=;
        b=tGJQGwCIZ0KR/UPBY0PoQh+AsCndB3U+ngT5/qO+pUnElhvGc994CwkcM3l853W/b6
         htOBPEBt20d7KbR7tsyGfMg6wGpywAsmjy9FnSMOb9dy0lRGwIaIYztEAreeTX5aTU43
         JI9Q1Aj5RBf4RmUhmNtM3VArT3cNpR3tnYlJ6ZQ+8hvQVwiOY2p71gQF5ieT+K3pq8vJ
         qQxcMX8ci+pZ25BQShCMLheHYSfGT0EFq7v9KBdKArLThO8zwdLLrxAzp+EQ+xRPAA4a
         h01HHWIgGZWsJfOC/zkVA4dymmasipYnfqkHj6D9APSw2WY59YSjCsjjEd3C9gz4jqRT
         eNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=8lQHQcNPbuMFQ0EQz27AnnoTfjTcciitO13KnmFwEu0=;
        b=jymbsKkVKw3TBvbQJOaMyHis2nXiAiuvzqfl6wAOzy2r0SpBKVPGPx/491nD/Bgqyh
         bQPD3qBYYDSAzVvemActk4XrltRG524NPvIwCFN+ZeB8Dx9DiH7s4tjZe2bwbZfJcpp+
         0rjViArGB5K1BxmMhxRFeyW0YW4qMtaaso58T67JVFGh2y12KrkAgqcc1S1FyXupWsaU
         Xky/uN4v1QxRSpenKJmJMvyK/hrtFlymsXNX0WtOJwVqxYuLM1z0AuapZN+jCh/x06I6
         TZg4cuPX8x2/pE9Gvb3nH1inUx6ADvuP7uGRh9ApmaSWuz1ZkaFarCuwQmFA4E/NniAA
         45OA==
X-Gm-Message-State: APjAAAUIl4nGrKSllV+fqkpVVrRW0nLhCGr/093RBSNrrknoaqcJ3ewl
        FiRPCs/a7JMD4bv3fcjhhd8=
X-Google-Smtp-Source: APXvYqxLdLAi4yYOYq3ZsgFiWt+Hc4osdj2aV+ceaEi/dNyTUR1Uj3aGTs2r/0QnirAG/qrNjSKwYQ==
X-Received: by 2002:a63:8c07:: with SMTP id m7mr8457014pgd.317.1573713450706;
        Wed, 13 Nov 2019 22:37:30 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id o15sm8927902pgf.2.2019.11.13.22.37.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 22:37:29 -0800 (PST)
Subject: Re: [PATCH] scsi: core: Handle drivers which set sg_tablesize to zero
To:     Greg KH <greg@kroah.com>
References: <20191113012739.GN8496@sasha-vm>
 <1573627181-20123-1-git-send-email-schmitzmic@gmail.com>
 <20191114060014.GB353293@kroah.com>
Cc:     stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <730f79ec-136c-9549-4453-4f977604408d@gmail.com>
Date:   Thu, 14 Nov 2019 19:37:24 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <20191114060014.GB353293@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Greg!

On further thought - the bug will only be triggered prior to 5.x if 
use_blk_mq=y is set for the SCSI midlevel, Quite unlikely actually.

Cheers,

	Michael

Am 14.11.2019 um 19:00 schrieb Greg KH:
> On Wed, Nov 13, 2019 at 07:39:41PM +1300, Michael Schmitz wrote:
>> commit 9393c8de628c upstream
>
> <snip>
>
> Thanks for this, now queued up.
>
> greg k-h
>
