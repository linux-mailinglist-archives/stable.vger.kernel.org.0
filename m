Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E56246536
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgHQLOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:14:20 -0400
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:40949
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgHQLOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 07:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597662858; bh=vSZ7gQ8F13hDNYtYk6t77g8qrdmtAY1S6LJUlA/r/r4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aBwnqg6rqn4XcFOF3XfQxWUHITR8D+maPfb54WDKnRxTzGCcrSxRSMlPK0g5R2dsfAaaVLoC+s4ZvGe5gU96qoOGyzxKnSIi3cFsYxBChHLsNgs60HCWX8juXohnTjeRupHvfFagPGFMbDTlRZtVsODdm33bf0YUbwoR3BjdcuY2yqe8zRVbAMn027Bzdo+WrpTRsaNLKZ5DQZ9E+rf0c5qQh6wq0J3MoByFxVOXCx4hLa8EGFdAMXAIvyVlUcR/gYevWw1vsb9e/SVuPwajwCUbh6xKSjnkAfQFsS8uc327aa2g3oVnBwTlCeez7Z/fXX7A/cdCBUWFEPzuNcxmQA==
X-YMail-OSG: 3KdVq0YVM1l_OLDCde5Eam30slX72K607lIUwPt.uUuRUAwmr9Kg.qLxGaLPw.t
 qeaH.BjFcCGINuYmFLnvKWBVJ2YXTxL3g7o.F_8O.UvxKnI4heUh5xRPgQl6zrfmtpEiGMBPPg9a
 WqiLi.46RAFX29EVsGRL7yxJM7vIBd3LsC1QeFBLLOPfeLSekZCaRBTVZy28TheT_kjrf8f4YMUz
 _INBkhtCNUr157v656deuJcGtueOYk.CdWxPZ_XObtXfYWW20t3gdMwuUnH0yo8BAW1ME8kwbv3L
 xEMUP_LT7Jx.qyJHXaLf62Zra3VJbDpNu4oDWl83k5b9jWtyRIIp2i5TDxxTgFrus87KltZ7UEbz
 puxAGnMXq4hHtfrSsjbLFSNmw5XdodYN5og9UosPHNbnbepKRKdWbFY3lXM_5lT4cImzueRxPd2F
 6EE5wnfm250w8WQWl2XSPKiujH97uSSRwqcFNABzqlp88hfivUtvn0.j_ztso0Hgh_yccX4XwA3K
 7rROH7myRGxBCCa_MNWkzxrRViuXlVQDaBCjXcfVbJ8Afg1stYBJuv5FVf08C7PazENAUgPlQy4q
 ieTgJbkYTi5Ct8UcDlzKuHo_f9700913_vGSXd9SaEXdq51RNBS5w19CNcDcUbw0L0Qgmrw6JA61
 JKhQuY8_sv8Nb4_f3t8Tw3WEBCdmPtyd43Rh48zPwCF9WEXkNSAuZG1SlJOoIDjyqGaziLU3rxKE
 NDe06DqmH6r2s_xrNH3bjkjKvfpe8vybfz1FS8NZN_fsfcb8_VuKM7A6Jo1GBPy7t3dmTiiKGpgs
 5cxrFZz40yid2DqyoVrvDhUB1Gtw4s2izfr2dx7tmsock0KMxVZhIcpJV8UEGM5mFa6TV9Bj..d2
 MzafyzUD9umThgSBlLOLJMiGvjNxQMVDfBKiaQuVCBEf4OnYgk8zF7dcF90.JhUBb4RIL71y1oft
 WnB.c1pSj4tWEK.lSfd5f8EBwCwuJaciK0FhbAIAgir2tQIviKPvt7t5_txOeAFvk55vzz4UH9bU
 3yq8cyCUK.FqMw0fDTM4BbmuMtZvG8CKzH9tZ0u2kX_U3rwlNcsQFx5bjjAZjCUkfgOSwXx2AGyy
 eedcvP1tHSwlhYasgP.VoPlSMUiLkLC7jxPHACv_A7JN9ALqlMsx2ysdXZH1idbsm2DPytGzHPy9
 LQGpMbgneXB3rsDu.PZ.peos54qkfvr_HaPNCCtMjaydBsunRJODFLvIns7S_.mbznGFDUkecN35
 byrU25IzXujZyNU0slOYdNFWjaL3P87_hGbrTvmwu_gmLD29sjyHSewFvDfuXghkq3NHDpMbFwHf
 9PKyLcjPIorlAWo916Euc6zMc8rw_XsCE1bAOSni2ItYO7NOfxfcAhw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Mon, 17 Aug 2020 11:14:18 +0000
Date:   Mon, 17 Aug 2020 11:14:17 +0000 (UTC)
From:   Mrs Faiza Mohammed <mohammedfaiza505@gmail.com>
Reply-To: faiza_mo303@yahoo.com
Message-ID: <1017314475.2253864.1597662857642@mail.yahoo.com>
Subject: Hello My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1017314475.2253864.1597662857642.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Hello My Dear,

Please do not feel disturbed for contacting you, based on the critical condition I find mine self though, it's not financial problem, but my health you might have know that cancer is not what to talk home about, I am married to Mr.Umair Mohammed who worked with Tunisia embassy in Burkina Faso for nine years before he died in the year 2012.We were married for eleven years without a child. He died after a brief illness that lasted for five days.

Since his death I decided not to remarry, When my late husband was alive he deposited the sum of US$ 9.2m (Nine million two hundred thousand dollars) in a bank in Burkina Faso, Presently this money is still in bank. And My Doctor told me that I don't have much time to live because of the cancer problem, Having known my condition I decided to hand you over this fond to take care of the less-privileged people, you will utilize this money the way I am going to instruct herein. I want you to take 30 Percent of the total money for your personal use While 70% of the money will go to charity" people and helping the orphanage.

I don't want my husband's efforts to be used by the Government. I grew up as an Orphan and I don't have anybody as my family member,

I am expecting your response to private faiza_mo303@yahoo.com

Regards,

Mrs.Faiza Mohammed.
written from Hospital.
