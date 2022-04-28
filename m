Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF027512C46
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 09:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244874AbiD1HJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 03:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiD1HJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 03:09:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFD2699180
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 00:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651129572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RX0IluUFjyFGJB9XgIGY/YNKpJD21MjW7iyGoQ/bciQ=;
        b=GMU4SvdQ5Fft+w+BzTviQoIV5fHrcvYPU52K6wLn55iE6zJEjRd3ooRASNHi+JUsdFgHfo
        Fzuog1aKjUALnwVhBtOQbfToGrOwXb3yXXTFyq3/eny4xL8EoD3LbUCcFklP6d/LUqFDVF
        rHHBXUJ9JH8tytC6BvyQntKDtG7LJ44=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-8AwWqm_iPSuqAdFpm-K45w-1; Thu, 28 Apr 2022 03:06:03 -0400
X-MC-Unique: 8AwWqm_iPSuqAdFpm-K45w-1
Received: by mail-qv1-f70.google.com with SMTP id 30-20020a0c80a1000000b00446218e1bcbso3040412qvb.23
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 00:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RX0IluUFjyFGJB9XgIGY/YNKpJD21MjW7iyGoQ/bciQ=;
        b=4b/PmglziZbH1ZdIUwjLoGtSogQHX7ZD/5CfgtFQbRzWCA140dW+U7s433VfJVVNDv
         O1zYBiUvTosmQhnIDEmeUxQi9xEKiZRQmUkY05tOOQ0twBsFMIAn7ydZiVStr9g9L3O+
         mRFgUFIZQ3cG0TA5CvxMTkCFseIsmDMjvWWc2ukqnhfbYAHqOWNZg/grfVOzwmixKwF2
         OIuy8xlPLHXoCP6cmLVHRM+H0lQ+ejjwiYNPvPUW9r4XwICShKKXIAX/HaHqYCtndGya
         G1QG5HSvR+C/JvhECccafAlaAFUiXei7LOdbIzV4tU9LIGAA3IirkydX8xROxruini9N
         xmOg==
X-Gm-Message-State: AOAM533QwnXYeFaPRcl95GD4+k6S9Vrh8Gv5LXTgJYs5ZTUjGdmqLuZD
        qIb8rXnnaL6A9U+j+gNNqmO93QFvsOyrY3pafOHmsuDAV29PczikRlV5KfT0K5xz7M+jtN7e30e
        sLoKjw553B2Unc0pf
X-Received: by 2002:ac8:5fcb:0:b0:2f3:4799:1649 with SMTP id k11-20020ac85fcb000000b002f347991649mr22339571qta.522.1651129562775;
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU2oeLrstNHTLoVNiOiYqy8PCp5qFcyD0PvqMZ6dBrsfSJtI6yAgZINx2lBg+bbQaYrXCEkQ==
X-Received: by 2002:ac8:5fcb:0:b0:2f3:4799:1649 with SMTP id k11-20020ac85fcb000000b002f347991649mr22339552qta.522.1651129562541;
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm11706888qtx.58.2022.04.28.00.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
Message-ID: <530adc71b52e774c92c53d235701710dbc9866a9.camel@redhat.com>
Subject: Re: [PATCH net 1/1] net: stmmac: disable Split Header (SPH) for
 Intel platforms
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Ong@vger.kernel.org, Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Date:   Thu, 28 Apr 2022 09:05:57 +0200
In-Reply-To: <20220428015538.GC26326@linux.intel.com>
References: <20220426074531.4115683-1-tee.min.tan@linux.intel.com>
         <8735i0ndy7.fsf@kurt> <20220428015538.GC26326@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, 2022-04-28 at 09:55 +0800, Tan Tee Min wrote:
> On Tue, Apr 26, 2022 at 03:58:56PM +0200, Kurt Kanzenbach wrote:
> > Hi,
> > 
> > On Tue Apr 26 2022, Tan Tee Min wrote:
> > > Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> > > of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> > > This SPH limitation will cause ping failure when the packets size exceed
> > > the MTU size. For example, the issue happens once the basic ping packet
> > > size is larger than the configured MTU size and the data is lost inside
> > > the fragmented packet, replaced by zeros/corrupted values, and leads to
> > > ping fail.
> > > 
> > > So, disable the Split Header for Intel platforms.
> > 
> > Does this issue only apply on Intel platforms?
> 
> According to Synopsys IP support, they have confirmed the header-payload
> splitting for IPv4 fragmented packets is not supported for the Synopsys
> Ether IPs.
> 
> Intel platforms are integrating with GMAC EQoS IP which is impacted by the
> limitation above, so we are changing the default SPH setting to disabled
> for Intel Platforms only.
> 
> If anyone can confirm on their platform also having the same issues,
> then we would change the SPH default to disable across the IPs.

Could you please provide a Fixes tag here? 

Thanks!

Paolo

