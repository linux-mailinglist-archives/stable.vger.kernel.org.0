Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742634446ED
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhKCRXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:23:14 -0400
Received: from verein.lst.de ([213.95.11.211]:60452 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhKCRXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:23:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F39F968AA6; Wed,  3 Nov 2021 18:20:28 +0100 (CET)
Date:   Wed, 3 Nov 2021 18:20:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 1/2] scsi: scsi_ioctl: Validate command size
Message-ID: <20211103172028.GA5881@lst.de>
References: <20211103170659.22151-1-tadeusz.struk@linaro.org> <20211103170951.GA4896@lst.de> <62249975-7bcc-f23d-808e-8a0da1131570@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62249975-7bcc-f23d-808e-8a0da1131570@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:21AM -0700, Tadeusz Struk wrote:
> On 11/3/21 10:09, Christoph Hellwig wrote:
>>> +	if (hdr->cmd_len < 6)
>>> +		return -EMSGSIZE;
>> The checks looks good, but I'd be tempted to place it next to the
>> other check on hdr->cmd_len in the caller.
>
> Do you mean in sg_io()?
> I don't mind changing it, but putting the check here in
> scsi_fill_sghdr_rq() was suggested by Douglas (cc'ed now).

Ok, let's keep it that way for now.
