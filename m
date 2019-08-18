Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04946915D8
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfHRJSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 05:18:20 -0400
Received: from sonic309-20.consmr.mail.gq1.yahoo.com ([98.137.65.146]:39637
        "EHLO sonic309-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbfHRJST (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 05:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1566119898; bh=ERxTzlBvLk6FX5GqUEorQfkZn2FwLudSxLDtMKxml+s=; h=Date:From:To:Subject:References:In-Reply-To:From:Subject; b=coTqkoO/yCyy9yWxe+DxUKZD5zwgAl7L92al52gq6IIHXWnJaNcj4TVIg3W1yv1FesGIwEl1+N0l1PgJ2o1MVJtuI7zkmTuGhXKltJUZUZ21hUSeAviaXd+5fodKh9CXifeBbnuNj4eq3rQ71dLmI8bUr0DGXu84NDz5QoNl6RFfF7wtz3i3+Sq2me6ppz1Y/gq7FupwZcDO+8Nm5PAvZUG3trnW/ELfB0XzZh9jrmlGIPj/f47GRWw3bjlMiE66xFCArzwVwrvq6CiUQvubLffFOy98accE1tMJ9PPnmpj68wJzf2XFtUL+5ItrrUDv61vSAsh8iOVCoCfCZ2Lq7w==
X-YMail-OSG: HJbkXHkVM1n5tAjXNktMZJ3fs7vBaOTlHBMbHs.mZKECYuXNw8JDUbsO7PusE17
 IH3jI_sxBfoA5Eey1dB2WdONWCBdLPkkpmgkFMLFg5b3YHbfLikA7badFys0_.V13zqDxtDvgtrY
 K1rlDEL_LmMZYbu0ScsBSKTUTlKg4c4YnY9EqnuX_WuV7VUQ4hQ.NDJKgd7g8UO2vA6H7AfPE9FX
 ulpAIOuwN16QcbSZ2UGW6Q_muwzrIWedRybApgRSYD.HLv4M_QKPgLjTq0ET8uKdVss5jHpniZbx
 H315BgZf.3XGxzoPPfdc3ZsQuOShDRJJOOVQktI.xlqmquWPNThiLMZrPPKerFPdAQz2o8FhpI41
 jN5IVClMU1Ob1La5fGyOZoAz4R1G.pPAThbVPGHG2TbBUjoBKfnrXD3MiJxXhobcLmZssmJFNBKg
 H33uZ.lDuMXaGBpTmCXFzje9bxZcJxRYDrktUl7nvIPlB5mc9dY.tX8utGg2Xmng6HwPUPDGsLSe
 MmumcXyfG8C8gP5LzNzLqdEkuIfy4gliYYxYjFQB4Tr7h9Mh0iI4Y6G2bjhTNy.CPOoWrAG46Fbj
 247sA5KTEengTxQ0yWwLupmkbwD6x6kjeJDjXtdi_r8SccGpiiHkGVMPxqpkqq12NhfvTwIBjidB
 wVKBYnTEWpoGZRt0SH_QPZHeDPseenA0fJaz1W97eKlcH6eGm5t9cYq6vw7i87sIzyWSW9282ahG
 5rR6uCXnyroVmHr8QjLOz.YHpjMFZ_Zjw1vfvGi_46wk5bDVp0Pf9E._sWzdfRPrd75KDV1AWT43
 EuBL_q1tsrPd8RrFoWeSD8vH4CanhYJ4.RQndf5g0U9VRtTIf67A3FQDH.qhzBgu_PDvrg7j9vgr
 EEqlC8j505mSBaIbtNjy1FutPZEDz3Rvv9FMpS5rVzwJNN3.Ga8SFa6JSoPgV.XcyRh9n3Qs3fgN
 KlmalCHY85juf9j9E27GN_ZkoefvHsvMuIX8oDqL8a2o6jmFjCws6sREQUuNMv6xQ.wdCja7OTDg
 3YFNJ7I0kAnGm21_FdOZ0L1PcmP4nIq7go12zE.0V83UYJ8682PrH8NkvkGeWcbR14ZkyquMeI2R
 5bjLoIzQ.OOMsh4Ku6W71b827Zs6pxwZ2bFNZNA2Eio0ARPO.7aDPo2hM0SZ_EuvVvMdb4K7dxRy
 Ccu8DmM2hF.3jy_PAslSCaXVh0yghMeevwz46O4b20DwSnvnAWPW_fst50YXH5T9bu8qiMxbY.Eh
 Owj5lqgehkI4HZJEg_prVmQSg8gMrnkxdrg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.gq1.yahoo.com with HTTP; Sun, 18 Aug 2019 09:18:18 +0000
Received: by smtp431.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 63c4f9f74aa8986cedeff92dfba4d06b;
          Sun, 18 Aug 2019 09:18:14 +0000 (UTC)
Date:   Sun, 18 Aug 2019 17:18:05 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Richard Weinberger <richard@nod.at>,
        devel <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miao Xie <miaoxie@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-erofs <linux-erofs@lists.ozlabs.org>
Subject: Re: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()y
Message-ID: <20190818091804.GA18675@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
 <35138595.69023.1566117213033.JavaMail.zimbra@nod.at>
 <20190818091037.GB17909@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818091037.GB17909@hsiangkao-HP-ZHAN-66-Pro-G1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 05:10:38PM +0800, Gao Xiang via Linux-erofs wrote:
> Hi Richard,
> 
> On Sun, Aug 18, 2019 at 10:33:33AM +0200, Richard Weinberger wrote:
> > ----- Urspr?ngliche Mail -----
> > > changelog from v2:
> > > - transform EIO to EFSCORRUPTED as suggested by Matthew;
> > 
> > erofs does not define EFSCORRUPTED, so the build fails.
> > At least on Linus' tree as of today.
> 
> Thanks for your reply :)
> 
> I write all patches based on staging tree and do more cleanups further
> than Linus' tree, EFSCORRUPTED was already introduced by Pavel days before...

Sorry, I mean "introduced which was suggested by Paval"...

> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=a6b9b1d5eae61a68085030e50d56265dec5baa94
> 
> which can be fetched from
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git -b staging-next
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Thanks,
> > //richard
