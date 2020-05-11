Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1FE1CDAA2
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 15:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgEKNBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 09:01:07 -0400
Received: from sonic312-25.consmr.mail.ir2.yahoo.com ([77.238.178.96]:43229
        "EHLO sonic312-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbgEKNBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 09:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589202065; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=rnvigWAwg8wKQzIXFjodOfIIeORHESeb2B2NnYjTcQzQtWLUxAmTNigVOhJp8B/NQvxyG7d/bFkgcYD2o/gZkBF4FVM4BVLpaiIPPfJoqT89dNfOm4GbXjyd4JwPm5xV9WxE7BCfXaOWxjpYaYZG3UAsYnGMySn4AJWi/c7KRRCDC5r6Uc7Au/S8QCMzTXGaUkgRt//C91FDI6Ons4k9AUQdPPtU+YEdiMIpHcrE2JbiT7e6FKsdBb7jgZN9i+RE9NshKKMWQF7jQSDTDF2tSBJx070yp/E4NMdWxoShNf6wt59qqlGmhZ4RsdFQl4Li1gFnfASermEXHVKJRgtJBQ==
X-YMail-OSG: ceKvXFoVM1l2sxrvaqzRRqDVZNc3ZyXbC5H0nPTKLA2RD736ckD2ZQCpHCfkktY
 A1XXSl_0GocPMlFTbJKL9X3T_NVE0AXnHdCooIM1CoyTu7UPh9TSuU7PsfO2MzDNUM3Sy4GrtHr7
 v2QfYMn8zHkGXGTJzPihfLCBYiGeQpQFIQ3V2qp9L5Mtc3L2xufghcKms8aIFEqtXib5gMxFcobm
 50Gl4k713sBGS2pWwaQL9w_VDWV6tQP7s.kV11rYd7p5f9x623Dx9kIAYdrHA3jcg5rL5iFiYAGp
 vBlq8RnSlW71SHdMShN0WPjrFvv7Zqg2K7jXQ1QbjNghDYmjia8tGEOYqXSQsiZw_4YVv5N2piqH
 N4lkKBed7t970.kWNDnU.dL9AwzJ6bfwQf9_Qp1X5L3Q7LMvV2NqvxN8I5hSHtng4H4OUZaK5Drj
 na6Y6fguyiSWf.rrNFUAMVeOYyjrugv.eZdM0fUvFVRoIcbNp5rDWGqFHnUmIhiineIX39b40PrE
 5TFDqNWPHnEaoyrZ3lFPTenKZaEFxIPidE.KIgN_TellSNPEqM39.ngZmxgkHLcSmQTfOD_NIxni
 JePU6IozgLk8r3zra.1BfQrCZW5BuYt0ktMYVnOFE0wLdPLZ.JneOek1zJCXye7shvFCoNYaZaLa
 yLiOW.u78Jc8mwxxBp6UKnkEGcL0cI5lvkDyr1uBs5XjHgk1UjScyBgJzzrmNSzprar5bgUUdjpl
 DxbJt8yv5NojtW2iSXzqa7k8Y9u1punfElCAv0F65kxYl5e1nLVzLNTva5G1UrgncprMU04nO3YH
 CHxOvsW93okq7p83v6B_aQoeeZn91hN2iV8Wxt3RU6sQE33g..5841MlvmkVd5kqwnuWImQ4l1mh
 szQ1G2z5roWY6O6zb3mRpBLQHZMWX4klXil298QyGWpl7k8PPirMfwbf4LXMyebIScnhbOXseOBa
 rFAx_fpw22V39ZFt5Y6zTP8rofwcnZFoW71GY9YDF3gyQL8l4jJZfolW22oa2Y1wvx.jduWYwg.r
 gFv7u8dgtKEvjcsOe_7r9Ts5sCQKr.by_k8VE9I7KC8g1AEVGryd8GJC3YXzm5zS2TSwNldzZ_L9
 aS2wsJOOOUZrMq9Ol22TS_taZiEIoE3A_rW3BDVMggSCYxAwMQwpDumaoucC3olqjdgj5NlC6uFl
 NfjNfCwMJm01uy0XtYhvNT77cmbXD4b6DNOhJEDUiLN576ttwZ6FLLohcMyqY5asyM67rkT8is1E
 QmLlt8s8bjlxiQJqlzRCROTX2XN9GydYe.E9nvlpZ27z6tZM07hZiecWqqIzisncVXyj5LhLZxNV
 ZJd.oVx3XrHN572mPFjpfiZ2G0A--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ir2.yahoo.com with HTTP; Mon, 11 May 2020 13:01:05 +0000
Date:   Mon, 11 May 2020 13:01:05 +0000 (UTC)
From:   Mrs m compola <mmrsgrorvinte@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <1841128328.2666188.1589202065048@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1841128328.2666188.1589202065048.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15902 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
Mrs.mcompola444@gmail.com
