Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3316BC620
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 07:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCPGeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 02:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCPGeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 02:34:08 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC40A674D;
        Wed, 15 Mar 2023 23:34:01 -0700 (PDT)
X-QQ-mid: bizesmtp73t1678948428tc83ll7o
Received: from [10.4.16.24] ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 16 Mar 2023 14:33:46 +0800 (CST)
X-QQ-SSF: 00400000002000I0Z000B00A0000000
X-QQ-FEAT: 3M0okmaRx3hcKxKpNBvZixBsS7cYrOvg3mMWMCpNPcLHGTCbBMetyQ5NkHikX
        Hzicsqh4CkLsk4mVq2WGOfyS3t2KuAiq1BiQGkVyUqo9eAHkNNMfCNJLCs+6kUlJh7h9HHC
        NzXKa7Uyz9gsiiacvlhhC5O84jQG/2XKblpAtdn/4QNd4tlATuRIGMkUHQfJjl8v8ySo4hi
        aG2tP7iEtSVtrWdhqAH7xjwVC8Qdgc2aXTDvnucl4VWrEX+jMnu20etB5whZzThLlZR9l4y
        E06t0FOHriFWALWiVcizaybcz6dAM82hChxUj/72OUhfEu4pyQXMEDxMsViGNGnS+g51+Gu
        3gYtdD9HNKTei0az0IpT0d232RxPdw5FeX7mOsBviD8fYV6PpA9uddmQvXlAmvazQ16zi81
        5ilmmBvl8gI0O6DUeBB5pw==
X-QQ-GoodBg: 2
Message-ID: <FB5EB3E66BC11752+d365c0b5-3ea6-c1d9-6e2d-9eaed541f6c1@uniontech.com>
Date:   Thu, 16 Mar 2023 14:33:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [REGRESSION] External mic not working on Lenovo Ideapad U310,
 ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Jetro Jormalainen <jje-lxkl@jetro.fi>, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230308215009.4d3e58a6@mopti> <87o7ou9jfi.wl-tiwai@suse.de>
 <927A9CC7D19E5BD6+6758c124-1a86-a981-d3cf-fa0da9ab589e@uniontech.com>
 <87a60djl5y.wl-tiwai@suse.de>
From:   tangmeng <tangmeng@uniontech.com>
In-Reply-To: <87a60djl5y.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023/3/16 13:54, Takashi Iwai wrote:
> Too bad.  So, if any, further fixes will be a guess work.
> Do you know the codec vendor ID at least?
> 
 From the information I saved as follows:

制造商:  Intel Corporation
型  号:  Intel 7 Series/C216 Chipset Family High Definition Audio Controller

And by my pci.ids comparison, the corresponding should be 8086:1e20

> At the next time you submit such a change, please keep the
> alsa-info.sh output for a future reference.
> 
Yes, I will save relevant information in the future.

Thanks,
   Meng
