Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E349169A
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 14:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRMjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 08:39:15 -0400
Received: from sonic303-20.consmr.mail.ir2.yahoo.com ([77.238.178.201]:45044
        "EHLO sonic303-20.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbfHRMjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 08:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1566131952; bh=/mcEyNhNZdsxaziyro/9XUfTujsutguSM01LgK/G9go=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=Xot5PEC74D+HgmV+TCCZeYFy6AnigD1cyEBX8QWCJk3pUpX8zPoUMDeGs0PpBwBHlnZ+bN8qXhRhvgbCO+DWhLuYkWdsNNB38gNdvaGg/YbxtIsoETx6Y2yd9OJ+DNglj4vT8Qul0jfZLurzMQRcLuox4AECFPn4jLp5El5/7x/Qw3VF76zsurmTDNcLrikmdEyBqw6VzghCRAsl0emD+7LPsga9AA3p955+6oKS/c0H3wTsDgolCDB9lJjRqEW98xocNnYekYjoHQz2VhWaiiC853ifxbMuXNDveYSGLAmcRjOn9XGCZvS7r3vWustd8ki86kEcPxd+nUMrOoyaRA==
X-YMail-OSG: UMCkWz8VM1l9vNkW4JU4htKV_mYcjxwTdIV2UF0tjG9JBHO3MMC9tiMszAh3BKd
 E9.IN.N91FE9PQ3sqyBEsQBhD4XxXZa8JIJ_FMcbtJh3odq7sEcz50mM3JhE0zplQaL0reahqMJf
 z9l6F3ENMtq4oOlE8N9M2Ye33R9f6Q9Vyi1Eier3vUhKZ8RCLFi0dEirJLqSaoov5YbBACGhfi8A
 nTRfhtzo7ksFrek3u9TvBO.lbMx9vzG2C4kgzui2KbRvTbloz8VyT0c0qa7NkXAlsSyuCp50ZHyC
 STEEIJuFsluxa8SAbHHYovvLXotocjVR0Ble3JwpLw93H3tzgrrkSZch_pm4DGat_.pIUaUVx3Gz
 vyMQFlnKGqgaoqLuhOKfAcyLM1sRz8REHv7DnRFCXVJaHYJMAxySgvW20.TmkB1xpLQPyim6iGBw
 wFfxzsWl8r0xuz1qkvjYJSLNcMj3vVuCtw07GLVV0k4ari3ncVcxB_n69rAi0xkYCSDdKMSXAvIZ
 AhS9j.W5jg6EiNR0Rttgsc.0WAMoJCvzuKtXAsqHzhwHPg0zJ2l8_cADSAQhKtNdcdQw57iJGWQl
 sqcUI6zzHm7eJww1SfLsCOWuczmSpAlMd_uYVldz4ZDCTPbbkmWcbMggLDiJxurX6YbLS.Kq6Ofi
 OETNnJi9gGZZpWYcjawQbWoXw76gkt7Bj9yFsZ6pPpbvcNInJfuFgxns4RKTQTwPd3xopxhx3s.2
 vwKQeMk5_qmK4gLbjWIJ1UHjv08KeDcN7PNeaSsHgK2TgNuBjLNJkGmng7sX7YEd8tv8ojI7szhv
 Q8KJIc5PFE07FIxRo0wbbZu4UOA_vo4SJL5PzCEqumEU4EDjI9osindldRhONALQPXaB_ShhFcOv
 VTH3Yac.8iMTBPSpw6eJSg5mi0mA.iKxljB.wDfliocg9wdmWI9mPq7QHTrspZ_rtBeYruryIBH3
 6jRsZ2ff9IuDL8twvrAvAr8De4qskXNj4VdZXSbCRI13kh6q3Peq2S_MISVj3i8ey8ZX4Mm7HtIl
 39EtaW9XtsItCjSqT5H5Kb4a85IwSerEd0ugfhkM0oDtYFgVos88j51BM7l7XUT4Vw8KPGcv4xQz
 r_cQ5.R826I5LBJQQtyGIiN3n4Y_kLXtOhBeCccsFmdm9ypJGFCy0uf.iRGJWapTdM10ilrDdcI_
 ZMrNUUaOm3PY8dQo8u.1NtMRcuSyuOf76UIcbvRLZ7pdZS1DDUnW9NkzxTLL1D.XPLJbS.4ohDgo
 Ix8iaFtqDqUpuHCNeSGUmjRRmT7IMoq_A0jU_5Ys5pA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ir2.yahoo.com with HTTP; Sun, 18 Aug 2019 12:39:12 +0000
Received: by smtp403.mail.ir2.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 5ac8cd491445deee6abef8e6b8855acd;
          Sun, 18 Aug 2019 12:39:09 +0000 (UTC)
Date:   Sun, 18 Aug 2019 20:38:59 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Chao Yu <yuchao0@huawei.com>, Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org, Chao Yu <chao@kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
Message-ID: <20190818123858.GA24535@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20190818032111.9862-1-hsiangkao@aol.com>
 <20190818123314.GA29733@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818123314.GA29733@bombadil.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 05:33:14AM -0700, Matthew Wilcox wrote:
> On Sun, Aug 18, 2019 at 11:21:11AM +0800, Gao Xiang wrote:
> > +		if (dentry_page == ERR_PTR(-ENOMEM)) {
> > +			errln("no memory to readdir of logical block %u of nid %llu",
> > +			      i, EROFS_V(dir)->nid);
> 
> I don't think you need the error message.  If we get a memory allocation
> failure, there's already going to be a lot of spew in the logs from the
> mm system.  And if we do fail to allocate memory, we don't need to know
> the logical block number or the nid -- it has nothiing to do with those;
> the system simply ran out of memory.

OK, I agree with you. There is a messy of messages when
memory allocation fail.

Since I don't really care apart from crashing or hanging
the kernel, I will resend the patch to make you and Chao
happy... :)

Thanks,
Gao Xiang

> 
> > +			err = -ENOMEM;
> > +			break;
> > +		} else if (IS_ERR(dentry_page)) {
> > +			errln("fail to readdir of logical block %u of nid %llu",
> > +			      i, EROFS_V(dir)->nid);
> > +			err = -EFSCORRUPTED;
> > +			break;
> > +		}
> >  
> >  		de = (struct erofs_dirent *)kmap(dentry_page);
> >  
> > -- 
> > 2.17.1
> > 
