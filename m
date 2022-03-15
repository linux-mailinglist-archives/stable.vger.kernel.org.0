Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842474D9AAA
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 12:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348055AbiCOLve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 07:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348063AbiCOLvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 07:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB823522F1
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 04:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647345018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eg2AsGFOKzlSa5PEdd6YEILMkb6GyS8DLFgd6knSfwQ=;
        b=Mnl0mQJEZ8DHcK+TIh0r/FYdCo9ruHT6f0X+tmqttbSZAkNvmcQU1ztCF8znmnX5VZncqk
        xfPHCU7VkYTQ2uwYY7C5tiaqXhz223Ui1EiFYtcZJ2estWCZrztzROS7byuZQkW2skv4Pi
        oHe4GYBdjNSuEPcCAVpeWMODMKUSQdQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-cFVmXPchP3e0fHhU23bKCA-1; Tue, 15 Mar 2022 07:50:17 -0400
X-MC-Unique: cFVmXPchP3e0fHhU23bKCA-1
Received: by mail-wm1-f72.google.com with SMTP id v184-20020a1cacc1000000b0038a12dbc23bso1119302wme.5
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 04:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eg2AsGFOKzlSa5PEdd6YEILMkb6GyS8DLFgd6knSfwQ=;
        b=PxS5pKMe+iFetwQ+UitFGuvW1nZqKubhSANFM0YAq0zWSbHXb3FFmNB51rYhU4SQX1
         cU98cFF0WrKTLyseMGlWth6744hnPF8nzM9CjTJqoBxsjILE6COVkIcog/wEv1iwMpfi
         Hsg2gtxf70k5UVnzhBEdhN8JxCmMj1HUZMS1wLtSLDmI2SrcLtis9T2iqqw7Yt1aGOWu
         3xowFU38aJbqM2qFY/gqeMpDyM41EcwHCLhc6FJTbfxI7EYsbuxWTxl1evJOA/AS1IDO
         YAlVtp/WtjJ8iSPD8aXvoz4qtEzzhPKFDWn3vxFRZZFxX2/IzjU3g2wr19Xp65qtbD7C
         xCpw==
X-Gm-Message-State: AOAM532eP+0d2g1mHlhOqwNS9PclkBYNZrAZHufF7QnqVPvFj42jr0hd
        Qvk5nS1cYsGqQMWR0CXmWQ2N+xLsomYqlatpjZ66Ku0oRolY+nDmWGiqq//4cU01jfgtzWUfRLB
        MsPn/baJ0KLmbJ6Jv
X-Received: by 2002:a7b:c1cb:0:b0:384:177d:871c with SMTP id a11-20020a7bc1cb000000b00384177d871cmr3013256wmj.84.1647345016134;
        Tue, 15 Mar 2022 04:50:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK2vBZ6ybjKAqlVVCN9ptVeUsYIbT21Rdh/id36VuiE1JyOD0da3yc1EyTY/ukMn1BTfV2Vg==
X-Received: by 2002:a7b:c1cb:0:b0:384:177d:871c with SMTP id a11-20020a7bc1cb000000b00384177d871cmr3013230wmj.84.1647345015866;
        Tue, 15 Mar 2022 04:50:15 -0700 (PDT)
Received: from redhat.com ([2.53.2.35])
        by smtp.gmail.com with ESMTPSA id f22-20020a1cc916000000b00380d3e49e89sm2013585wmb.22.2022.03.15.04.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 04:50:14 -0700 (PDT)
Date:   Tue, 15 Mar 2022 07:50:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, jasowang@redhat.com
Subject: Re: [PATCH 5.15 015/110] vhost: fix hung thread due to erroneous
 iotlb entries
Message-ID: <20220315074834-mutt-send-email-mst@kernel.org>
References: <20220314112743.029192918@linuxfoundation.org>
 <20220314112743.460512435@linuxfoundation.org>
 <Yi9p8xsrWV+GD9c3@anirudhrb.com>
 <YjBaOClDdNQkxtM8@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjBaOClDdNQkxtM8@kroah.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 10:19:52AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 14, 2022 at 09:44:43PM +0530, Anirudh Rayabharam wrote:
> > Mon, Mar 14, 2022 at 12:53:17PM +0100, Greg Kroah-Hartman wrote:
> > > From: Anirudh Rayabharam <mail@anirudhrb.com>
> > > 
> > > [ Upstream commit e2ae38cf3d91837a493cb2093c87700ff3cbe667 ]
> > 
> > This breaks batching of IOTLB messages. [1] fixes it but hasn't landed in
> > Linus' tree yet.
> > 
> > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?h=linux-next&id=95932ab2ea07b79cdb33121e2f40ccda9e6a73b5
> 
> Why is this tree not in linux-next?  I don't see this commit there, so
> how can it get to Linus properly?
> 
> thanks,
> 
> greg k-h

It is in next normally. I was sure this commit was there too. I'm not sure
what happened, maybe I forgot to push :(

