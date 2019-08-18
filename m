Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBBB9142D
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 04:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHRCdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 22:33:05 -0400
Received: from sonic302-20.consmr.mail.gq1.yahoo.com ([98.137.68.146]:46001
        "EHLO sonic302-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbfHRCdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 22:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1566095579; bh=chMdXfotk825PO9swgg+VAwAuaaWOwEFrVfLHlz++j4=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=Cm8JtLfIOBgMY/RbDxYoiTqPe9QscmduknXvS7tW6ohHhuM+ZviyrjxR62NyCf7kLEiIT2i1OwaHh5sNksgSOwPbNZtsHMChtQybHpWBS5mEC6Zuh4n+qcOiq7AVkQ5ofYTOW5H6URXtxPJjOoKQBO/dUIfM2vPyxaygeGIMCiZNwrzjV8tDUu0pjZz+9VIbDjW2pL2man/nCGdhlPEAaWunZ1gfB5QmmD0MdjfbQVNJUcn8JiN16HXAsv1BIdmrDXgSyrR5a+ZeAjfzGLj1dYxiLi4WZX6i/yPSl63eFvUjs7Tgnijk5zkRlJY92MlUVKV3TJlKxqJ2EvM+rAKnLg==
X-YMail-OSG: 3E1UZKcVM1mWOD.muEhr2WoF7Twz6rQmnZX9lHOt.ne3Asc2x2co0mLmxGmw.yd
 DISwDVWf498kSratRHsZIwCgokGXtplOrHeub47fSJ_kNW7CDpltkAIseJzmw30rNwi8guSw4DqB
 HGRn5rqXT4wAubTrlPmgXcPTrZLeO0vQ4rDnKXqMpGS_mbJvxnXyUubSPo3Q2lITPuTabJ023..o
 lzy6gwZJ3GnrxUxXz4s0rdS_qfZu1gcRbhRBDg2mHG6.p8qJnPgJjBcBsv3QuxlhQ1h_ohqnJuyZ
 R3KJe6hAYNKz4gaG7t72GY_108v9BSKDQP3PGPabIhe88xUb_rteDPnQutO2VgdX7NrzxHFHjEn7
 8vbg9hXNrf_plaee.l4xjpABX_Hr0lANJGR86UGXLST8obzv7EMqCQ6LyKt8ERHLcV3kT4Sg3ma0
 fP0nxu6pViQK2AMmtbjWRnWckq4qebUUMRpeKfz5ovKrr1ZaPAXE8Rc2HhuQKtBtL3D61i9GQXSv
 .XLQ_l6Cl6mHnCh_7b0olSvjalaSMGVN9oyGvOhg6ZOz0KlaQF4ZWAW0nLSNAeMKeYj9Koc98teA
 1Z5yPtLZRBb7D1xEagvf991GLsmj8I9cKSY5AoRjlBpKY.oJIiCTq9ULrcOyNXRmcbwy0lD6oxNf
 2w7vP6LEUxfn6Bk1_oMUEn9N8mkWGIt6MpPeDFzb_RLW_YArNfQJfo_fQccSXbd0SaU2csN1o.O6
 XevhxtMRqkz0v_Jlyw7FOmvzxE2U1nl7pTIOfY1E4A48iMH6_HTkvWvWba20qsQCCGTRf_mqustB
 oLTQiY2bjwq6xSEabpY8rH9oqz2MWgceNiqRqEWLBN1ooe4_1DKKaKve6IiE8agBzYIuti4Qojdc
 9aT5YE4CBzYEV_DzmnOlFJYpdFBF5A.ciczrubEbSKH_K.z5xaFILWLDdBEHgOfKoy7K_2JEvYW4
 TbKHvpyi1MOp6uKa2OmKRvnf1dSI4VXluEldXGJefcj6gDGrzZVpaG6bLx.iSWwkYm5vZiE_lvLJ
 8sqPH7UyPIdrOomMWz6nXAZA8g1oK_mcKZ9wpuiACpMuBg5YTHlj8Ur7wXey3WpQj.798RtljYRT
 TSEFmAGo8tWr4G.G6yUq55LaVoRzZ0Y9bt5_YzAANW2pnldflcJlx9x3lnOZynRT7VgzWGPZay.C
 M8JkT.fxeFLcT3ytLU7nrBxlXqB2ENDd9TMi.iX_fCfsZS2gr5v1sc2ndkzpwAQ8FFndAhbspPmP
 aa_tbW8pXygD4RXwYlpPyqavECSRcZ97Y_g--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Sun, 18 Aug 2019 02:32:59 +0000
Received: by smtp418.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 248360bfecbb1cc8d8e234253b4a5d4d;
          Sun, 18 Aug 2019 02:32:54 +0000 (UTC)
Date:   Sun, 18 Aug 2019 10:32:45 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Chao Yu <yuchao0@huawei.com>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] staging: erofs: fix an error handling in
 erofs_readdir()
Message-ID: <20190818023240.GA7739@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190818014835.5874-1-hsiangkao@aol.com>
 <20190818015631.6982-1-hsiangkao@aol.com>
 <20190818022055.GA14592@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818022055.GA14592@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Willy,

On Sat, Aug 17, 2019 at 07:20:55PM -0700, Matthew Wilcox wrote:
> On Sun, Aug 18, 2019 at 09:56:31AM +0800, Gao Xiang wrote:
> > @@ -82,8 +82,12 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
> >  		unsigned int nameoff, maxsize;
> >  
> >  		dentry_page = read_mapping_page(mapping, i, NULL);
> > -		if (IS_ERR(dentry_page))
> > -			continue;
> > +		if (IS_ERR(dentry_page)) {
> > +			errln("fail to readdir of logical block %u of nid %llu",
> > +			      i, EROFS_V(dir)->nid);
> > +			err = PTR_ERR(dentry_page);
> > +			break;
> 
> I don't think you want to use the errno that came back from
> read_mapping_page() (which is, I think, always going to be -EIO).
> Rather you want -EFSCORRUPTED, at least if I understand the recent
> patches to ext2/ext4/f2fs/xfs/...

Thanks for your reply and noticing this. :)

Yes, as I talked with you about read_mapping_page() in a xfs related
topic earlier, I think I fully understand what returns here.

I actually had some concern about that before sending out this patch.
You know the status is
   PG_uptodate is not set and PG_error is set here.

But we cannot know it is actually a disk read error or due to
corrupted images (due to lack of page flags or some status, and
I think it could be a waste of page structure space for such
corrupted image or disk error)...

And some people also like propagate errors from insiders...
(and they could argue about err = -EFSCORRUPTED as well..)

I'd like hear your suggestion about this after my words above?
still return -EFSCORRUPTED?

Thanks,
Gao Xiang

