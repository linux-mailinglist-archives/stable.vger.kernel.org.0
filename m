Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B506E547B46
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiFLRrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 13:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiFLRru (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 13:47:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1981260D8;
        Sun, 12 Jun 2022 10:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99141B80CAB;
        Sun, 12 Jun 2022 17:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B28C34115;
        Sun, 12 Jun 2022 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655056062;
        bh=0P1FkJULx7MNqMxRzMRCDaaLavfRB9H4gZqhC6TxSzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lL/uUaJccZuX6InLCXYRs0+MKzuxf49kESZJffT+G59wXgCd97UyMCgynHJ8Ar2NH
         ZdwOLABW8SwlFgybSxy1fUodKWzf03HB8W0LyQXod+srCEkeN1lcNoPMiEFyOlvS69
         a/BIWvVRcGie8jp0BKSNT+bA2FGoJS9J98PE8TuEjE+SGD9x2emBaz5PZFNNeT+IkA
         jdmhBcMd++EOtT2pdtffbyxKFdWv+HzFlga+uFQuS56Lm0PSPlbRGAxsTjniQX+ZTf
         vlmTSi63K+FutD+G/TPHckdsvbpzid/erCf2rGzhT2ubyRDlJiFavztCWGOa6olBXg
         hx0LY0tN6BIoA==
Date:   Sun, 12 Jun 2022 13:47:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheng Bin <zhengbin13@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, trix@redhat.com,
        salah.triki@gmail.com, speakup@linux-speakup.org
Subject: Re: [PATCH AUTOSEL 5.10 21/38] accessiblity: speakup: Add missing
 misc_deregister in softsynth_probe
Message-ID: <YqYmt5wAXWt7Ggzu@sashalap>
References: <20220607175835.480735-1-sashal@kernel.org>
 <20220607175835.480735-21-sashal@kernel.org>
 <20220608210830.GA1306@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220608210830.GA1306@duo.ucw.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 11:08:30PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Zheng Bin <zhengbin13@huawei.com>
>>
>> [ Upstream commit 106101303eda8f93c65158e5d72b2cc6088ed034 ]
>>
>> softsynth_probe misses a call misc_deregister() in an error path, this
>> patch fixes that.
>
>This seems incorrect. Registration failed, we can't really deregister.
>
>I checked random other caller of misc_register(), and it does not seem
>this API is unusual.

Uh, yes, I'll drop it for now.

-- 
Thanks,
Sasha
