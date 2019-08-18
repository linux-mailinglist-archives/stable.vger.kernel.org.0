Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BDE9158F
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 10:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHRIdf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 18 Aug 2019 04:33:35 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:51488 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfHRIdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 04:33:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C2CC4621FCCB;
        Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id XeZIT_USZWky; Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 78A63621FCDD;
        Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7lybuVzrZDKf; Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 21F18608311C;
        Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
Date:   Sun, 18 Aug 2019 10:33:33 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     Chao Yu <yuchao0@huawei.com>, Matthew Wilcox <willy@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-erofs <linux-erofs@lists.ozlabs.org>,
        Chao Yu <chao@kernel.org>, Miao Xie <miaoxie@huawei.com>,
        Fang Wei <fangwei1@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>,
        stable <stable@vger.kernel.org>
Message-ID: <35138595.69023.1566117213033.JavaMail.zimbra@nod.at>
In-Reply-To: <20190818032111.9862-1-hsiangkao@aol.com>
References: <20190818030109.GA8225@hsiangkao-HP-ZHAN-66-Pro-G1> <20190818032111.9862-1-hsiangkao@aol.com>
Subject: Re: [PATCH v3 RESEND] staging: erofs: fix an error handling in
 erofs_readdir()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF60 (Linux)/8.8.12_GA_3809)
Thread-Topic: staging: erofs: fix an error handling in erofs_readdir()
Thread-Index: Rcstd4mNm/okj9qGD1bM50Z4foHydA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> changelog from v2:
> - transform EIO to EFSCORRUPTED as suggested by Matthew;

erofs does not define EFSCORRUPTED, so the build fails.
At least on Linus' tree as of today.

Thanks,
//richard
