Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB2E39FB1F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhFHPrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhFHPrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 11:47:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5EAC061574;
        Tue,  8 Jun 2021 08:45:48 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id u24so25046328edy.11;
        Tue, 08 Jun 2021 08:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=punlm3oWnlQpGTmoym5vrb/f2rcna+QtiUgMPDsatf4=;
        b=H8Nu4vT7bsEjPWBvTOWc0dWdP+FG5G/I4YCfBVfu4PkWO+nUolranjpmoHNC/nQ1mZ
         Z/9EdWAQgrWHuyyOrrYHtQjWpClx8WLYUlo/m5QzvCyk06NB/2YH4l21WEjaP4wbiPQ6
         Q65RjoLea5WU49AD2bNym37JA94b1gf5uS3UJoHxoVqkBX3dB6s4nhAHHCKmE7C3yD3d
         o3iFnekVNMxSA8r+LPg/yxrbpdSHzu9WLe4Y5vHFPqYonOupxSRG7hSBPVjmRtNMTc2p
         4/n+KlBp+kJnD0FqDQm/QvGyrYxfcdLBqjQ8gpFVvC6mjAGT23IB/vinVC7XYjIC5y5K
         t2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=punlm3oWnlQpGTmoym5vrb/f2rcna+QtiUgMPDsatf4=;
        b=GezEf4TibyIq4KOaPYA+yBKm0mUDbj8VLjO7+mYubSfbne2Qed5J8YofcQvfkch60q
         yg+wOnxc3R5RkIPXxhPhHOwp2DVdh9GGqy8xfCQKxXfZipzSwT4iO7RPZHaKYyIZvVHX
         iPevI29MA6JIM0XnfVaxd4wUytuwt4iKXm7HMeMQFtNyzwyzKFnmwnPs4q/HXdQDN7oI
         PYc8iEqxPbnk2djV4lGhw0teP4aU87izW4/nhKd7qNK1V9JsoeiuhfMeaH6zAF5crCcE
         isbnErXA1cam5F92mJbJnZLg70vdJ3IPsmM4EIP/VPoIhIpu393tnrK6Vd38HNB6myaG
         o2cw==
X-Gm-Message-State: AOAM530ATMOiBIOQr1hKiRIH1lIFyUTXCrssYn9YmHC0DEQhCpxKWLkV
        zLMCPxUay9JIGakXEO1UluLp8nS5rVNrJQ==
X-Google-Smtp-Source: ABdhPJy0UifSThFXavPmbq1T1ZvkgmL2HZgrxBBMEZm3HoBZDjx3q74MkxtTxIXipLDHcVcXv9M8Ng==
X-Received: by 2002:aa7:cc19:: with SMTP id q25mr25588574edt.56.1623167146925;
        Tue, 08 Jun 2021 08:45:46 -0700 (PDT)
Received: from [192.168.178.196] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id p10sm42670edy.86.2021.06.08.08.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:45:46 -0700 (PDT)
Subject: Re: Backporting fix for #199981 to 4.19.y?
To:     Greg KH <greg@kroah.com>, Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com> <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com> <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
 <YLpJyhTNF+MLPHCi@kroah.com> <YLzAw27CQpdEshBl@eldamar.lan>
 <YL+AMiD7falsvZOf@kroah.com>
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Message-ID: <41c228f1-451e-d5b5-f4a4-bd1bf13389fb@gmail.com>
Date:   Tue, 8 Jun 2021 17:45:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YL+AMiD7falsvZOf@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 6/8/21 4:35 PM, Greg KH wrote:
> I do not see a commit a46393c02c76 in Linus's tree :(
> 
> Are you sure these ids are correct?

Sorry for the confusion, I think the correct ids are 
d737f333b211361b6e239fc753b84c3be2634aaa and 
b1c0330823fe842dbb34641f1410f0afa51c29d3.

Thanks,
Laurențiu
