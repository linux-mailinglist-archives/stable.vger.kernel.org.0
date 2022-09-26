Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FACD5EAEC0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiIZR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiIZRzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:55:36 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6DF63F06;
        Mon, 26 Sep 2022 10:32:56 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28QHWcvb001686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 13:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664213561; bh=YMM3AaX/KN+4rmSmHEPW/8P60W72WjElwRSGsItg/ME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=EXRHbov4H+arsPBg4xbppsLVAiSCAd4h8YWgCZXz3ek8HCYT5liQCykeuhSSJxKUz
         dtMbMHCUgptChMoyuX1SspUc63WFD+GHNvUcn7gzKKQtGak4EzK7YkTV3gBF//Qv2g
         2bvPotzOfgW9LN6G7cjKMEPoIJUSI/0H9KSBDrBes1X5LwXMKDxPTEE1Zd2rdHDSm2
         QnAdLUSLnmDYyWdOBBm2Y2fwAlvAvqMf9hTLd+x0jEHKS0KcLXfZlQ7oOpBZK2dSRc
         n4aA54/9Pw5eh8ICIGCk8N1wM3GFRi0Vx3tgdgFmXYNJEltCisvclksGy0JRaVhJ/D
         DN1wh1T+K4jcQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3E1F515C526C; Mon, 26 Sep 2022 13:32:38 -0400 (EDT)
Date:   Mon, 26 Sep 2022 13:32:38 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     harshadshirwadkar@gmail.com, stable@vger.kernel.org,
        ritesh.list@gmail.com, stefan.wahren@i2se.com,
        ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org,
        regressions@leemhuis.info
Subject: Re: [PATCH 1/5] ext4: Make mballoc try target group first even with
 mb_optimize_scan
Message-ID: <YzHiNojNLa3u/yuf@mit.edu>
References: <20220908091301.147-1-jack@suse.cz>
 <20220908092136.11770-1-jack@suse.cz>
 <166381513758.2957616.15274082762134894004.b4-ty@mit.edu>
 <20220922091542.pkhedytey7wzp5fi@quack3>
 <20220926091126.yx25wgeibxabmcaj@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926091126.yx25wgeibxabmcaj@quack3>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 11:11:26AM +0200, Jan Kara wrote:
> 
> Ted, I've noticed you've merged my mballoc fixes (and pushed them to Linus)
> without this fixup. Can you please merge it? The use of uninitialized
> variable seems rare but possible...

Oops, sorry my bad.  I had forgotten to merge the fix before I pushed
them to Linus.  I'm preparing a follow-up push to Linus right now.
Once a smoke test passes, I'll sned out the pull request.

       	     	  	       	    	- Ted
