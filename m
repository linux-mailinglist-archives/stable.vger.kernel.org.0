Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80AB6AC2E8
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCFOSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 09:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCFORz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 09:17:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD55730E83;
        Mon,  6 Mar 2023 06:17:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E87DEB80E5C;
        Mon,  6 Mar 2023 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53CFC433EF;
        Mon,  6 Mar 2023 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678112134;
        bh=iUGI7sA+NyB22Qteehn6lk2CUwj9IOOkRxrj6W/Hkvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tuPiegm2NOTM68BT6+MpJQ3KUsr2s3xkd1soIThRWbZCTVCKgOpaYNJj3JWJT+OLv
         /d5TQaeLP9O5Yuc3HzsKqtjgNzPUixSNZPzjXxV4MGBSk8UplKV4XHtm/2lcBnm1b5
         wVSGGRYY0BeGNQzR3VARRiy2X6/Ulu2wo6vl9xLlFKchlBosWx+x0LkcjN5H+yqN0A
         7l7Pd8uYJQRhYCeejdMxMmoYFoWGB4Cms+F1eVtWfY3Y+sIz6lg3YZVDP4p97bJzOd
         KXaSTMzAsXW635Ow7Hkk1SVUWkyiYbBJ9TKrCJfQbDBnjFQHeWTFHnNnwQlTvm1WCt
         4aMwjt2PZIhbA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pZBdP-0003Gt-4q; Mon, 06 Mar 2023 15:16:15 +0100
Date:   Mon, 6 Mar 2023 15:16:15 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Abel Vesa <abel.vesa@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] soc: qcom: llcc: Fix slice configuration values for
 SC8280XP
Message-ID: <ZAX1r1xXgnJ7fwIX@hovoldconsulting.com>
References: <20230219165701.2557446-1-abel.vesa@linaro.org>
 <ZAXkIHOom26DlVx0@hovoldconsulting.com>
 <ZAXxYPZ/zarxcsNF@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAXxYPZ/zarxcsNF@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 03:57:52PM +0200, Abel Vesa wrote:
> On 23-03-06 14:01:20, Johan Hovold wrote:
> > On Sun, Feb 19, 2023 at 06:57:01PM +0200, Abel Vesa wrote:
> > > The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
> > > LLCC config registers. Fix that by using the slice ID values taken from
> > > the latest LLCC SC table.
> > 
> > This still doesn't really explain what the impact of this bug is (e.g.
> > for people doing backports), but I guess this will do.
> > 
> 
> Sent a v4 here:
> https://lore.kernel.org/all/20230306135527.509796-1-abel.vesa@linaro.org/

Looks good, thanks!

Johan
