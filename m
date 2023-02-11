Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C90692F34
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 08:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBKHsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 02:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKHsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 02:48:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497033C7AB;
        Fri, 10 Feb 2023 23:48:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CADCC609AD;
        Sat, 11 Feb 2023 07:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A3C433EF;
        Sat, 11 Feb 2023 07:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676101696;
        bh=T/q0JCnr09rho4ViJZVwrVO4Mph36UL2mDXTPaKlKSU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lYZCMaSrqkw0NiwqhW0JLp1Mu7+/vKE4W+sWaFbU2MbfEQudn0SuThkMZOnNz+tuh
         nHo9EyK9bL6SA2uGGHXBZf1Gc5KfUaUxwpIFj2H0Ud6czGDOz2Eh+E0K/o3EDLUTBC
         XDSEsrlDEuf+yUrFTa+fHMM4vZzhLsSiPBI8/0Ew=
Date:   Sat, 11 Feb 2023 08:48:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alok Tiwari <alok.a.tiwari@oracle.com>
Cc:     linux-scsi@vger.kernel.org, darren.kenny@oracle.com,
        michael.christie@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, r.bolshakov@yadro.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: core: Added a blank line after
 target_remove_from_tmr_list()
Message-ID: <Y+dINRZ9ZKLhvT94@kroah.com>
References: <20230210175521.1469826-1-alok.a.tiwari@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210175521.1469826-1-alok.a.tiwari@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 09:55:22AM -0800, Alok Tiwari wrote:
> There is no separate blank line between target_remove_from_tmr_list() and
> transport_cmd_check_stop_to_fabric
> As per coding-style, it is require to separate functions with one blank line.
> 
> Fixes: 12b6fcd0ea7f ("scsi: target: core: Remove from tmr_list during LUN unlink")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 5926316252eb..f1cdf78fc5ef 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -691,6 +691,7 @@ static void target_remove_from_tmr_list(struct se_cmd *cmd)
>  		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
>  	}
>  }
> +
>  /*
>   * This function is called by the target core after the target core has
>   * finished processing a SCSI command or SCSI TMF. Both the regular command
> -- 
> 2.39.1
> 

Why is a coding style change tagged with a "fixes:" line and cc: stable?

thanks,

greg k-h
