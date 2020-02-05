Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4152B1533FB
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBEPhA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 5 Feb 2020 10:37:00 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2379 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726661AbgBEPhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 10:37:00 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 256C9CB93C1F74D8EDE5;
        Wed,  5 Feb 2020 15:36:58 +0000 (GMT)
Received: from fraeml704-chm.china.huawei.com (10.206.15.53) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 5 Feb 2020 15:36:57 +0000
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 5 Feb 2020 16:36:57 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1713.004;
 Wed, 5 Feb 2020 16:36:57 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Sasha Levin <sashal@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>
Subject: RE: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Topic: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot aggregate
Thread-Index: AQHV3A/jJwoPNNxgYk6BJdeHa69IC6gMnNwAgAAa96A=
Date:   Wed, 5 Feb 2020 15:36:57 +0000
Message-ID: <66d58599356749a7a533d700cefa025f@huawei.com>
References: <20200205103317.29356-3-roberto.sassu@huawei.com>
 <20200205144515.1DDE4217F4@mail.kernel.org>
In-Reply-To: <20200205144515.1DDE4217F4@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Sasha Levin [mailto:sashal@kernel.org]
> Sent: Wednesday, February 5, 2020 3:45 PM
> To: Sasha Levin <sashal@kernel.org>; Roberto Sassu
> <roberto.sassu@huawei.com>; zohar@linux.ibm.com;
> James.Bottomley@HansenPartnership.com
> Cc: linux-integrity@vger.kernel.org; stable@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH v2 2/8] ima: Switch to ima_hash_algo for boot
> aggregate
> 
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.5.1, v5.4.17, v4.19.101, v4.14.169,
> v4.9.212, v4.4.212.
> 
> v5.5.1: Build OK!
> v5.4.17: Build OK!
> v4.19.101: Failed to apply! Possible dependencies:
>     100b16a6f290 ("tpm: sort objects in the Makefile")
>     1ad6640cd614 ("tpm: move tpm1_pcr_extend to tpm1-cmd.c")
>     70a3199a7101 ("tpm: factor out tpm_get_timeouts()")
>     879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR
> read")

Hi Sasha

this patch is necessary. However, backporting it won't be that easy
as it was part of a patch set. Before this patch, users of the TPM driver
could only read the SHA1 PCR bank. The IMA patch needs to read also
other PCR banks.

> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

This question should be for Jarkko (added in CC), as some patches for the
TPM driver must be backported to apply the IMA patch.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Li Jian, Shi Yanli
