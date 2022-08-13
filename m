Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311D1591CFC
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 00:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiHMWR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 18:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiHMWR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 18:17:56 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0766A51418;
        Sat, 13 Aug 2022 15:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660429071;
        bh=UF3uFQaAJ971E8vhPiKhwDtYTU2Q/panS+SBFaCif5Q=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=RyUhCRWPMjbOXzxt56i7kpqmoeqEKlCOKwGzH64eWET7rlUXzCypwlth4KACS2wVe
         /iyPYJ1cLwaIqbfOH+OTM3nsj/7PA352i0+qIfE9Ti6AUgg6HHAhb2Nf0F9Sq9IkRW
         WXTyv6AOegY7Q1xlXtPk4ggZXaG1PJz7MuVZUffM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMobU-1o6Z3q0CXM-00ImUR; Sun, 14
 Aug 2022 00:17:50 +0200
Message-ID: <b10f1e72-0846-f46c-816a-352646ae5661@gmx.com>
Date:   Sun, 14 Aug 2022 06:17:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659600630.git.wqu@suse.com> <YvESBmvjMqIXvqjp@kroah.com>
 <Yvejlr1Nds8wtyKj@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <Yvejlr1Nds8wtyKj@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LyKhzR3dDLPxZfY5yUPFn52uNzEVoCZ0RAwTIGGSZocoLAk/voL
 IunH/du7pLU5no26empxRkiyTnAlde/h9tdnRST9pO7KRWaDSXJZMxSmnUIIfOaIK3EnkT1
 UxUuDc87Wsj8ZCJx1Q0RCFmILWlLVwcpQ0Auq6yopDJSizzAqEIQQ4tLD08zjeQ9RCcBpsB
 7bGvwG66qOAIY1a7pm5Ew==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Rt1pgHqZMOQ=:tvsGULfL5FihZgDEsB9ZXJ
 6DSqcFgfnfXVdTn8OyXIz6surTKrg/JrVhwNNbcYTUUXktp0M4h/btbK6nVm2LitfFRtI6PRa
 vGVMUMfjYcyC8KDEvZjmVrCpZe+XV1DT3mzg0B7rE8MCpW41xkXOBDrDyxET/PRAQ+i1bvoDD
 +i/+22M/GzgTNc2BX93MjzomS3MWUV+ROBRFMhkDvged8mlBiwFRia9yiozYtRUCD1XgWUCmj
 IyNYoBvYIIzWjyZ5XrWJPB7/MrPIqKbVrEP5Jd+7A3OFnrOPgBa1Jietn7AlAAiZuS9+Uusjq
 tmZXE9o2A9dhBvHU77fujv+p0KzPNBrG5LjOu17nkJppNZfjbQKkY/Y2ltLzZUt8iaXj6Zv88
 ZnsyYt7EE+kzqN/sbL4xHboynsjzT9NdUzyYkvT+835GJrhVc6VdSTbskVXCB1LEhTHEgybiN
 lZyEsVXA2MD/Aiyfq7VHCsi6n3LZgHR6hnDUJ3hO19d1Gtdd32PMoh3PGULnJHwBot4yDcy+j
 XKgOEvqmno95zceWBWKrrknw8QnUGSO6aadQuzXsdGM1C4FmG/aQllD/+skdwudw01wULOCne
 gIv+C/ZnhJIYcTxcoIzrPrY1eh6b+5P2BMdGH+JsKPTVXTEQ91FlaBh+1+BB5yY1y1hCjjQkQ
 uDJ/ds/+Rwa3dikOUUiRldFna6qEfkccwGmtZ38iuRy7dA8cGKCodJMVjt3uTtUCaInx3WM5Z
 M+CR9juRP6aLV0CgBw75Yljx28NGGUUXlEySHVqFVZgqhU8Ox4L/16oKqy6j1I/mWw50x6rdM
 GXi0SfXpfkiCC+8i89YB0RwNhELBr+dZzA8e7W0YBFtPk7pWSFE36QkrnRoOE7KQwIZvzXLhH
 1u+w+ROzK4s1kaEFh9WvWmE4KX2vA8JwiwhPjlrA62ZI6xtlsZRfBKZTC4OSAeDtOSpVu2Nxn
 ikXvyUV5cDK9rlrzFtJE2O/anIwsM9eEgobwUk8kF0ikW7Z3gu1YqByKzTEXTtcZNxahgwXVR
 dWh0Y3EiYU6bvfOVPXsXX8CdbSj2yuwxIufi/qBToQzKcSQNVBcADJnDInE6xaJ7bXd+VntEV
 0InNIkaIXJ1glYs8jXf1jTujM83zQ+PEJuAon1AMIiJxUYh8KcB1GXQmA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/13 21:13, Greg KH wrote:
> On Mon, Aug 08, 2022 at 03:39:18PM +0200, Greg KH wrote:
>> On Thu, Aug 04, 2022 at 04:10:57PM +0800, Qu Wenruo wrote:
>>> Hi Greg and Sasha,
>>>
>>> This two patches are backports for v5.18 branch.
>>
>> I also need these for the 5.19.y branch if we were to take them into
>> 5.18.y as you do not want anyone to suffer a regression when moving to
>> the newer kernel release.
>>
>> So I'll wait for those to be sent before taking any of these.
>
> I've dropped all of these btrfs backports from my "to review" queue now.
> Please fix them all up, get the needed acks, and then resend them and I
> will be glad to reconsider them at that point in time.

To David,

Mind to give an ACK for these backports?

As mentioned in the pull digest, these two backports are to reduce the
possibility of data corruption of RAID56.

Thanks,
Qu

>
> thanks,
>
> greg k-h
