Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD41EFB19
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgFEOXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:23:18 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35176 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728766AbgFEOXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:23:16 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D415F4C84F;
        Fri,  5 Jun 2020 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1591366992;
         x=1593181393; bh=E1NE57bdzzLLiDsjNC/LwG7ogqoub6rklwDXfB2z25A=; b=
        a1aCNOIv1WK/Az5l1xpHBCnedVVWnM6tUfBh8tIpjdLM1xa7lwZClEUgwHNLH2Lr
        I04+giArzaAZ2qj2fC3A9jCt9BiMXHktRxZg1pSqH/U9M7Sh3xnn9kgYS/fC2XAg
        gPZuvbXIh6XZke3fGvQTyd9yrG4ckf/2yeehtnXBqzY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 84z2rE1vd9eN; Fri,  5 Jun 2020 17:23:12 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 710274C164;
        Fri,  5 Jun 2020 17:23:12 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 5 Jun
 2020 17:23:12 +0300
Date:   Fri, 5 Jun 2020 17:23:11 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Message-ID: <20200605142311.GC56901@SPB-NB-133.local>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
 <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 09:42:06PM -0400, Martin K. Petersen wrote:
> 
> Roman,
> 
> > The driver performs SCR (state change registration) in all modes
> > including pure target mode.
> 
> What is the current status of this patch? There was a bunch of going
> back and forth wrt. whether this was the correct approach.
> 
> Thanks!
> 

Hi Martin,

The patch has a logic error that prevents session deletion if N_Port ID
was changed after fabric rescan and shouldn't be merged IMO. I'll send a
correct v2 shortly.

Thanks,
Roman
