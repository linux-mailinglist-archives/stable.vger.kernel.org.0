Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487FC222217
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 14:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgGPMBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 08:01:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58637 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727030AbgGPMBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 08:01:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id CF20C5C00ED;
        Thu, 16 Jul 2020 08:01:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 16 Jul 2020 08:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=OKr73vCti4bFblGmMb69BINrdrP
        ppP6UKgi+39pFjDc=; b=ftg/+qYGtojlQ2Tbck945AomimC0uj5swacufwaOQjR
        meNtwBfUMSnvnMAUmJulvrVF6iTRKS/GmET5WOcWsAOjr66gXmI7OHQ0O/FNbCC4
        j021wh2RzAoKbUcgkE3IcUPR/LIdoAIhDDH0bnmVZAIk1UC9tl9X3oxPtYfCLrXz
        cBOHPBCgDAn3KgQW2R05ojUB8q44JHCDoF9zrsV9qCYB4JSOPzbZ2CvVhqKs88vg
        mD1JG41A2HK0TegZasLVRocajyiUp07MqCH1CfimXZXavv+xKrfhx2EvzeXt1bl+
        adIgOGfHhti1ZD5/teLMw0eoisxBmEDnU3kxKxkZfdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OKr73v
        Cti4bFblGmMb69BINrdrPppP6UKgi+39pFjDc=; b=iStjl+L/TPUDQYZXVv2z1G
        7PqFZXH7jcBvsMeuk++ah3gKiJuSDATLzlOaAPlasRNIMC28i98qZbmaVFmIZshM
        1mUsgv3D7ctKW/vulTyY/G7GvBSO1KEEXWjMj17B+8vThWWnUBjgBf8xFwrLRXVV
        rT/raPyJ5bpAF/7Su+p4nBMjIDNT1BpTvjiXf7ovy/D6vi1Tz8B34g8RVRwaCYCx
        hEo/8vJSqi2Iyp0BJz7ai8wiKOjeS+HRTOD3PBA7j2CxXtRHfqmz1gmDcsxGkgER
        REpuzr6DGaMGoSAOfP9SMWVSWW+E62o+gEhCXwm9ct7duDnSH0OeqWOjEKuQKv2A
        ==
X-ME-Sender: <xms:okEQX2hb6l-1I45nF4gzfsfklDTmfXZMzlggu2pqbkcwdfx4w4WR_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfeeggdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:okEQX3B3viD6VpiI59ushpf7nxl03aRufB8KLQ-tcuTk8s0RBKNi0g>
    <xmx:okEQX-HSB0MXnzvAbebCyWkLdfnra4psaolBCtubxHwbA-1iw8yfgA>
    <xmx:okEQX_RbGlw1wbNSZ-r4sSCjy7QHKMSAkPxx4WYD_12IznLqlhljzw>
    <xmx:o0EQX-pKuYLQxBoSpt-uNUdyqjW-K7i1Ksur8VCPu0d6Z1qGioEIww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57B99306005F;
        Thu, 16 Jul 2020 08:01:38 -0400 (EDT)
Date:   Thu, 16 Jul 2020 14:01:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianmin Wang <jianmin@iscas.ac.cn>
Cc:     Marek Vasut <marex@denx.de>, changbin.du@gmail.com,
        linux-stable <stable@vger.kernel.org>, acme@kernel.org,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org
Subject: Re: [PATCH] perf: Make perf able to build with latest libbfd
Message-ID: <20200716120129.GD1668009@kroah.com>
References: <20200128152938.31413-1-changbin.du@gmail.com>
 <70322330-524c-14ab-aace-e460677e25e3@denx.de>
 <20200601164727.GB1037203@kroah.com>
 <46FC68D5-0AB5-45F7-8851-555779C5685F@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FC68D5-0AB5-45F7-8851-555779C5685F@iscas.ac.cn>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 16, 2020 at 10:07:15AM +0800, Jianmin Wang wrote:
> Hi, Greg KH,
> 
> There is the same problem found on Linux 4.19.y, while compiling linux 4.19.y
> with binutils 2.34.
> 
> Can the follow commit be backported to stable branch 4.19.y as well?
> 
> Commit id: 0ada120c883d ("perf: Make perf able to build with latest libbfd")

Now queued up, thanks.

greg k-h
