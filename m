Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1D4D9C3E
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 14:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347971AbiCONbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 09:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiCONbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 09:31:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C0FF51307
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647351022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZtmaY3QY+M2yy/RC8DM8e+OTFH19E+LWuDTX+tqqXg=;
        b=amzF1+A5GXZrdNsxPMVmTO67B2kDWpnwelbzpmZgJvyofRY24qzibvJ83g0yMIuwsk+GV4
        NnQjO51jGl6c/k01fJ/Z3GHF3MU4/Mi9o0CAEsG0iUG04lHTDlWGM3jBJg+wfkBV4zk7o4
        DK5EtsMZFjg9e2b8oXQ+XRrk5NMti4I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-0pqzCze7O5ifmDtNdow7lA-1; Tue, 15 Mar 2022 09:30:21 -0400
X-MC-Unique: 0pqzCze7O5ifmDtNdow7lA-1
Received: by mail-wr1-f69.google.com with SMTP id a16-20020adff7d0000000b001f0473a6b25so5289242wrq.1
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 06:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZtmaY3QY+M2yy/RC8DM8e+OTFH19E+LWuDTX+tqqXg=;
        b=l3wocCQoHgrOfoMSrAEUfsmMTr5wS/RoGwarhCNY7HhG+PNMwxjvS+SxHYKoksG2H3
         nnaahCO9GSvF3S7sccdyKXaFnmu0o3fSNUvju3bnUM+eUFo+lw/ErVsQCk2+TzE1APTD
         iWjGhPzIeIxtZqHdubaYvGHuiz35xTrz+1QyPJlJVIi7F3f+x7OoUG67JMJwmAsxg6nS
         CXVg7uLH0u7shlms2DYb+rrI2DynUd/IuQ1rV7q81AP08ei0LUa1pCh1j4VPgC0phBGL
         KkKYRLQK+vTLJWf0IqA32pLdDuCClIxqBpL240rS+SwSRx9Wxfvh3Ljl6Y6RAdiqtT8B
         mltw==
X-Gm-Message-State: AOAM533+oV2rml3+h+F+s+ygeEg4/KoUTuiFyxvuJEs5kBrMUn9Pp/vq
        zppH5EKHRrPbg3sfT7sgyq64xsfPglViZ+YOQ0a75U2ZLS2GSRRInQeSvdXrA+O3QfHA7MtlCEZ
        ObQ7obhRgI7agPK4R
X-Received: by 2002:a05:6000:15c1:b0:1f0:73d6:b716 with SMTP id y1-20020a05600015c100b001f073d6b716mr20330939wry.293.1647351020078;
        Tue, 15 Mar 2022 06:30:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdY0tDepaN3E0R9C8xSHxKp7c5DEvBWlJLZSGDDqbc8x3hCbPBn4KS7IxZ9d8Y4vz2d7ox3g==
X-Received: by 2002:a05:6000:15c1:b0:1f0:73d6:b716 with SMTP id y1-20020a05600015c100b001f073d6b716mr20330928wry.293.1647351019893;
        Tue, 15 Mar 2022 06:30:19 -0700 (PDT)
Received: from redhat.com ([2.53.2.35])
        by smtp.gmail.com with ESMTPSA id w10-20020a5d680a000000b001f1dabec837sm15515573wru.113.2022.03.15.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 06:30:19 -0700 (PDT)
Date:   Tue, 15 Mar 2022 09:30:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com
Subject: Re: [PATCH 5.15 015/110] vhost: fix hung thread due to erroneous
 iotlb entries
Message-ID: <20220315092949-mutt-send-email-mst@kernel.org>
References: <20220314112743.029192918@linuxfoundation.org>
 <20220314112743.460512435@linuxfoundation.org>
 <Yi9p8xsrWV+GD9c3@anirudhrb.com>
 <YjBaOClDdNQkxtM8@kroah.com>
 <20220315074834-mutt-send-email-mst@kernel.org>
 <YjCI/Gd6oFiC1J8Z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjCI/Gd6oFiC1J8Z@kroah.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 01:39:24PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Mar 15, 2022 at 07:50:10AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Mar 15, 2022 at 10:19:52AM +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Mar 14, 2022 at 09:44:43PM +0530, Anirudh Rayabharam wrote:
> > > > Mon, Mar 14, 2022 at 12:53:17PM +0100, Greg Kroah-Hartman wrote:
> > > > > From: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > > 
> > > > > [ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]
> > > > 
> > > > This breaks batching of IOTLB messages. [1] fixes it but hasn't landed in
> > > > Linus' tree yet.
> > > > 
> > > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=95932ab2ea07b79cdb33121e2f40ccda9e6a73b5
> > > 
> > > Why is this tree not in linux-next?  I don't see this commit there, so
> > > how can it get to Linus properly?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > It is in next normally. I was sure this commit was there too. I'm not sure
> > what happened, maybe I forgot to push :(
> > 
> 
> It's on kernel.org already though.
> 
> Anyway, I'll just take it from here directly, thanks.
> 
> greg k-h

Thanks!

-- 
MST

