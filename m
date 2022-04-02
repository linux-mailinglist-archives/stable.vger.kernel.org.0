Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32AE4F0142
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 13:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348735AbiDBLrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 07:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345518AbiDBLrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 07:47:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3108A102412
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 04:45:50 -0700 (PDT)
Received: from [192.168.165.80] (unknown [182.2.36.61])
        by gnuweeb.org (Postfix) with ESMTPSA id C07A77E35B;
        Sat,  2 Apr 2022 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648899949;
        bh=X14l+V8LdbqkPVyoxKIt3c19pBxXQcKS12fLDPG+f8c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Du61JKS6nA+tb297WzIE6xvBcMQWDMg387+pbuEgKlSuifvXgZGQwEIAt/4woHtg0
         +/SEG2VGlnEH/UIZ6jc20MI8RCtn6bO2Ya6I29GGXMxlO4c29i+WU/jVxWF6vhd7uz
         4PFOtvu+5J1G6uo9/fmU8ho4TI2NVBeY3XerSpIjYks939MLKFA0CArlGrHrM6NQym
         ZJd5MEs+KlHTRUNdsEynx/0vG2BDWUbctcXrIsAuUnS7uBwcDP8Hz6PioH0ojErNBG
         WhsJRZQVZSXeasuEAGQZq850XEFWdVS1AGap8rkk3KowxxD+I4jKEL+XljNoC8TfrF
         ySnTDWNJRiQSg==
Message-ID: <ae44d3ab-3b08-c6f1-36a6-5b987f769c23@gnuweeb.org>
Date:   Sat, 2 Apr 2022 18:45:37 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference
 when ENOMEM" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, broonie@kernel.org,
        daniel.baluta@nxp.com, kai.vehmanen@linux.intel.com,
        lgirdwood@gmail.com, perex@perex.cz,
        peter.ujfalusi@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, rander.wang@intel.com,
        ranjani.sridharan@linux.intel.com, tiwai@suse.com,
        yang.jie@linux.intel.com
Cc:     stable@vger.kernel.org
References: <164889914960214@kroah.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <164889914960214@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/2/22 6:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

I will submit backport patches (5.4 LTS and 5.10 LTS) for review tomorrow morning.

Thanks!

-- 
Ammar Faizi
