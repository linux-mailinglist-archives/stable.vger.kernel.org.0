Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA142782E0
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 10:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgIYIig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 04:38:36 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57817 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727663AbgIYIig (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 04:38:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2682A60C;
        Fri, 25 Sep 2020 04:38:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 25 Sep 2020 04:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Sbuwq9C7nJF0H7UX6X0WnN/Z4pM
        7dso/fwnREu3Gu60=; b=fh5Pi1IUr0qw1a972djJwT9Ra974W9nUoHnsc1nEd6w
        4wYS3SgTYNcRPysQgtdBgeLTZ7j/bSVCZfAPhx9xLAghCBWQtpD6QSSm2zlqk3st
        54G245+vh+cpSQN8qUVf95aQmcO8ZiNkNU45ffIf0G9qjEDWJX6mfQpXobiNSA31
        hrSrjs88cAgmsKYLRntO3TCFqIWyX7ewqJhDQShQZWbtJh7tI45Pw8RzlK89kedt
        kvj6uJLCf9ZnlwUUgl9INmb2u0mqvgsMhVQPXZksFl9d7MnZfP+o63KPHo4zCmXo
        xvxRgHgJHmWS+zzeU5X30TEB8Y6jRAbU88Ngzd+Fitg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Sbuwq9
        C7nJF0H7UX6X0WnN/Z4pM7dso/fwnREu3Gu60=; b=pH32Nyi/QzJFJcg4rubpk9
        I4DxWsU0JmwhE5gIQSA6usKo6se6jsZiiEn51cUNxxFD8wX53acTal1NlxCOeTZz
        Nn+6hcYTrayjGLH5erfSvNZbWQZxLBgvqAI/WwA6PIW56csVyOuCHARBxQJRqTO2
        /yfmO9+s2EoIWYFnTlDmIhiGaqVptDB8lIjmcC8gYeqTmrNSFVMQ9GPC57uJ/Tkm
        Wec/H+GYICpW7UOdBXBiEkPj3JMVAKZ6qTy0dSw6qQZzlzeTFzTxhjoZTJqKUWV6
        21MzUVK5yp/PuLS+n974LvMqjSq1KkJLkl6YTioms9szHxU/6J65iJo0eEvwCeIQ
        ==
X-ME-Sender: <xms:iqxtXzuwAGXXzgSvxcc5SrAQ8Mk6UEgEpwsd3lExyR88xpAs0Io70Q>
    <xme:iqxtX0cn-ofVzK7UMPORrpdT6ASEs1ntDKjv3TKaGSLmcazAO0kyhZolpXwGiSWBe
    Jn3T0EiQxsN2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iqxtX2zboGPB-XQUkpMRjoBiU228dBSSiiCYWz8UaCe3JbqILkVoAg>
    <xmx:iqxtXyPhEyV6bj9SgdTzgAbywL3Iv6xyLvVhadPe1bQNDWWHLv3DYw>
    <xmx:iqxtXz8SRMik7qXaEKaoQZeZshvVTnYLdbtHmrTVeeasuCGhG_Yz1g>
    <xmx:iqxtXwJcqxulgpmJJer68_tcjAMqOVr-PJF-n6mCFBZS1eiyccuYMA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A4B13064674;
        Fri, 25 Sep 2020 04:38:34 -0400 (EDT)
Date:   Fri, 25 Sep 2020 10:38:49 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200925083849.GA1449004@kroah.com>
References: <20200924.144001.2148078165712329256.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924.144001.2148078165712329256.davem@davemloft.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 02:40:01PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4
> and v5.8 -stable, respectively.

Thanks for these, all now queued up.

greg k-h
