Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15970619344
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 10:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiKDJRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 05:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiKDJRj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 05:17:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E286354;
        Fri,  4 Nov 2022 02:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA75B82C4D;
        Fri,  4 Nov 2022 09:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC1DC433C1;
        Fri,  4 Nov 2022 09:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667553456;
        bh=SHbE2LcdkBiwyRM/AvlDZQO5hSel5lKZUzSHsY5egTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s0Y35Tx6AgDHYPTZqZKJamKbZOHDz1uMAchts8vfXYcjIHFhT+kfGD6yAbDsj5ZtJ
         mrJD75Csnm5uib1QAG4++hwbBoKfPjcGUURWT/7/Q6wiRxx62gC6owoXlu5RzD5/nh
         qOTUlO0T8ZsO09Oie4Dubv3Av+jAeNxNV+lLR8QI=
Date:   Fri, 4 Nov 2022 18:18:15 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     TGSP <tgsp002@gmail.com>
Cc:     rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
        huanglei@kylinos.cn, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiongxin <xiongxin@kylinos.cn>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PM: hibernate: fix spelling mistake for annotation
Message-ID: <Y2TY120EAhfKgSvR@kroah.com>
References: <20221104054119.1946073-1-tgsp002@gmail.com>
 <20221104054119.1946073-2-tgsp002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104054119.1946073-2-tgsp002@gmail.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 01:41:18PM +0800, TGSP wrote:
> From: xiongxin <xiongxin@kylinos.cn>
> 
> The actual calculation formula in the code below is:
> 
> max_size = (count - (size + PAGES_FOR_IO)) / 2
> 	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
> 
> But function comments are written differently, the comment is wrong?
> 
> By the way, what exactly do the "/ 2" and "2 *" mean?
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: xiongxin <xiongxin@kylinos.cn>

Please do not use an anonymous gmail account for your corporate work
like this.  Work with your company email admins to allow you to send
patches from that address so that they can be verified to actually come
from there.

thanks,

greg k-h
