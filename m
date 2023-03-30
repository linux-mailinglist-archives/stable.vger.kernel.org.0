Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5882D6CFE54
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjC3Icc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjC3Ibq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 04:31:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B11D6A72
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 01:31:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E53B8264D
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8FAC433EF;
        Thu, 30 Mar 2023 08:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680165077;
        bh=i03g/+IiYS/vXG0yeL+qmZTIyYwpBoUK497JFQSVZQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=al1nhc7wCV66jo8ISedX5zSzz3JQDxeFieynGXaEb4+qYU9fCHCXlZ9q8oHJILhc6
         N6+gZjPpLXLAOImfkP0YjpzwIT0Q2Cpa82/uQ3C41LpLAgyJ3xLl5Lmi937S/aeQOA
         v1rMZGLQS5QodYoqAiyCaZAqF0pbLTI8E51kd3C4=
Date:   Thu, 30 Mar 2023 10:31:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Adrien Thierry <athierry@redhat.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 5.15 082/146] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCVI08p-yaaKG8T0@kroah.com>
References: <20230328142602.660084725@linuxfoundation.org>
 <20230328142606.118680029@linuxfoundation.org>
 <ZCR5Zef4oHYFkAss@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCR5Zef4oHYFkAss@fedora>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 01:46:13PM -0400, Adrien Thierry wrote:
> A possible regression was found with this patch [1]
> 
> [1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Ok, I've dropped it from everywhere now.  When it gets resolved, please
let us know what commits to pull into the stable trees.

thanks,

greg k-h
