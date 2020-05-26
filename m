Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB981E2D92
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391217AbgEZTV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:21:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:42168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404481AbgEZTV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:21:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC284B1E9;
        Tue, 26 May 2020 19:21:56 +0000 (UTC)
Message-ID: <06a74050412a378acf31f41ce5e39c6c739ee91e.camel@suse.com>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
From:   Martin Wilck <mwilck@suse.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        stable@vger.kernel.org
Date:   Tue, 26 May 2020 21:21:52 +0200
In-Reply-To: <20200521151730.GA73599@SPB-NB-133.local>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
         <3ee76f0fc5df716523bfbdd34726b6cccd4971cd.camel@suse.com>
         <20200521151730.GA73599@SPB-NB-133.local>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Roman,

> [...]
>
> So, as a summary, it seems that the existing code mostly keeps
> sessions
> until:
>  - a conflict of N_Port_ID, N_Port_Name or N_Port handle detected;
>  - the session is in the middle of refresh/rescan and RSCN arrives;
>  - there's an explicit process or port logout from the session, i.e.
>    PRLO, TPRLO, LOGO
>  - there's a new port or process login from the same session, i.e.
>    PLOGI, PRLI;
>  - target is shut down;
>  - target port link is reset;
> 
> And if a session of an initiator is deleted when driver works in
> target
> mode, new session won't be established until a PLOGI and PRLI come
> from
> the initiator.
> 
> The assumption is used qlt_handle_cmd_for_atio() and
> qlt_handle_task_mgmt() to discard commands and TMFs from initiators
> that
> are not logged in.
> 

thank you for this incredibly extensive response. I'll bookmark it,
I guess it can serve as a reference for future qla2xxx work. I hope you
didn't do all this work just for my little question.

Forgive me that I won't immediately try to review this document in
detail. You've studied and understood this driver in much more depth
than I probably ever will.

Thanks again,
Martin



> Thanks,
> Roman


