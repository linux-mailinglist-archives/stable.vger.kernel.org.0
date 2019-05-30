Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F98F30222
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbfE3Soj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:44:39 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:33012 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3Soj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:44:39 -0400
Received: by mail-qk1-f171.google.com with SMTP id p18so4614541qkk.0
        for <stable@vger.kernel.org>; Thu, 30 May 2019 11:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TP8qwa9bFK7NFf69y+6nuD/Rj/Tkum/YLtDiaznw/zk=;
        b=iGGsfgIWOnESCeTKRI1vhV5K1ummCk4WqBKYOfMe5sMDaXavz+HBstuXM3RwHncmuM
         6gHnbkB6w8sOMo/5Vb/RI9Sr+PL9GlTLfC6cBEEJ6reCkM6DSIHxxwd9d6d554Vr44nw
         N83a2GCAXgcdicBF4e8aVKzBGE1KIT3Cj4rYxa73lk5WjFO2MZKath3dDYK5pt5Iyuqu
         ESyZh2CK8RfZBOBGSuEramSqQvhqmyQtPCNyqB/fxBHXy8Z8BQ0Irk/dr8RC+WHsIEA8
         wrRQ622vSmfylyo1mph/rVkMun/6rbqx760jS3Vxw4pNm/bxU8grQCq/s+Qrwfvj76Bo
         QZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TP8qwa9bFK7NFf69y+6nuD/Rj/Tkum/YLtDiaznw/zk=;
        b=LqfkxHux6QoNCFEguwjtnmBnn/LwiW+kVU8l6bHbMe5KjIsXc25vU8DBMh+dkcnee1
         2am/WGwkqP/UyAesrIqmxv0KY+CxYQW3G1qUKx/tSD85a1XjEMcfykuhxT7Ix/yD7+zr
         eScPK6bodB65fixblwWN+szJ/pvk0rZZJ3IqiKSAbjX7jfXzypXVaw8frQj+PXGUbKbs
         Yx4DUa7X4c7kTyTsx9Gz1bMP9GFjbVcr1Ah1gAA7y8LdcztXSTbVB9GXokjuLjl8db5g
         YrpO5byFccWvI6ie/4DyCN10H+L71vnci0jcl+mr0slXD7nfCSVSUGF2kypEjzm/fGY1
         Uiuw==
X-Gm-Message-State: APjAAAX9GTTFDDztb//7d8pK/Q/f4vH6KFDR+4NkbZnL5Tbf7blEEx6f
        623RFsVuq7dGCbWd5SIZKAFhXw==
X-Google-Smtp-Source: APXvYqxTkYAcWdM96OFgtvEHPBL33vEIMWOThLloG2x5ZdOiI/82rb0b11rYmw1ZGFn757LKXPZDFw==
X-Received: by 2002:a37:bd86:: with SMTP id n128mr4624184qkf.318.1559241878551;
        Thu, 30 May 2019 11:44:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id e66sm2194653qtb.55.2019.05.30.11.44.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 May 2019 11:44:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hWQ2X-0007lm-MM; Thu, 30 May 2019 15:44:37 -0300
Date:   Thu, 30 May 2019 15:44:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do
 not have a port number
Message-ID: <20190530184437.GA29836@ziepe.ca>
References: <20190529163831.138926-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529163831.138926-1-bvanassche@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 09:38:31AM -0700, Bart Van Assche wrote:
> The function srp_parse_in() is used both for parsing source address
> specifications and for target address specifications. Target addresses
> must have a port number. Having to specify a port number for source
> addresses is inconvenient. Make sure that srp_parse_in() supports again
> parsing addresses with no port number.
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)

Bart, do you want this applied now, or are we still waiting for
Laurence?

Jason
