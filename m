Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B8D6CC178
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjC1NyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1NyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:54:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B4C6183;
        Tue, 28 Mar 2023 06:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E85AE617E5;
        Tue, 28 Mar 2023 13:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011D5C433EF;
        Tue, 28 Mar 2023 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680011657;
        bh=Sn0QEYc5cNok75sM8qmUtgYoGVQ03cX7/Vd3NqXdQNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xbNBvWaS+2M1Lpseqk509mE+/GwOur+2aOnAyqF/xfKMfZceypLWchbM9QScno980
         Svc3G6HWZC/WwgRsx2VSBsaYhQx3l+L0jwf/dmhmxCqTwhwlNseGER8gbxQU1YLhjm
         3R2oGoxi3tKomWOQtSjDggGRHMhMSzLXM7RY7PCk=
Date:   Tue, 28 Mar 2023 15:54:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] Two more xfs backports for 5.10.y (from v5.11)
Message-ID: <ZCLxhswcCY8i5mcq@kroah.com>
References: <20230328073512.460533-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328073512.460533-1-amir73il@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 10:35:10AM +0300, Amir Goldstein wrote:
> Greg,
> 
> Chandan is preparing a series of backports from v5.11 to 5.4.y.
> These two backports were selected by Chandan for 5.4.y, but are
> currently missing from 5.10.y.
> 
> Specifically, patch #2 fixes a problem seen in the wild on UEK
> and the UEK kernels already carry this patch.
> 
> The patches have gone through the usual xfs test/review routine.
> 

Now queued up, thanks.

greg k-h
