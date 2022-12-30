Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B56B659AA6
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiL3QnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 11:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3QnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 11:43:00 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122CA12A80;
        Fri, 30 Dec 2022 08:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672418577; bh=e0P6eeby/jXuaq4qykOZsW6E67jOj2VFHjq5q5H3kIQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ueq7xfWQNL1aqI4sE16+M5GMJIqBaYdUCArmdmiH+yi9uacUX7g3sh/ZlXrQ7xYHG
         6+s9FY85GqVp6SZAsJG55mcLG+B2w3MBhs+GDm2fp2z1VlvFjQYj5yQ2uAqLRd+H1n
         UDwCb7e19r6XtQGbKsrvGPbDpOi2CEpLyoickOpgKfVPZUwqNdN09DGvBM6N+zQMPI
         wpjnQ7eW2b/vJ20+MOGp327KLE+PkHvck55G25td4psKRmvh8B2BO/+HPWRXfpljMg
         ya9oWq+fZf1Pmhilkgx8rE5kqyMBCimQ2Ybr/tQQhaD6dhS4emhRvdyPJrnyqAzC0S
         OIkgV+4CgIkeA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.18]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MYvcG-1pOaAL1Jg0-00UvFq; Fri, 30
 Dec 2022 17:42:57 +0100
Message-ID: <09f5b49a-d3e7-5204-8dbf-f6bcd05a3f56@gmx.de>
Date:   Fri, 30 Dec 2022 17:42:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:VWy3G785yCgEywHVVtHz2asgHYTFietZKsNOxay1dHfUhp3KyyI
 r9TJeM++ddSTx92Z0Iu6fSNeW/r7ZWoW1cCQz6Kh8Z9XdmpekelkXCgglh0zk+sLu00P/4l
 i5pzTatpArUZjubv6OMXplhHG9AwilADLSG5tfH5Fs4kX9YQ+m52sOIP499lPEFHPfep7gM
 IL6QUmXl5wC/OEWdo4rxQ==
UI-OutboundReport: notjunk:1;M01:P0:tTYO5NCxEfw=;Bq6tr/lZ7kRnLkh5djpx2lvmOZK
 ZqAJ9+iLVrM5XUb+lcU9sUENBfm1Byu2Af2Mh1mXrdwy1iNheXpd7iAHguTTdQAuP3+LHURNF
 a3SDl5AA7Z/9IyCU7S3dLKQxGXKqecy3kmS+4mFXSJsWFRmFj1pGrhHiYhe74DUn2/5smbAWh
 M4fnCmihsj5lNFr8UQdQ6vM4oQhH0QFUKFjYrK0TAYRZrET61KPos2uBYiARkAe0G+eRKi3B7
 xB2yZxU34BEN/Igko4EJbEMTGeKmLdJeVEWvZST+Ogfl4uDHDviTyVBgqtiH25KPRczfE+gV1
 3l8rLkxzbpm7QqyAZ3JCpMvuIqmSPHb7K8e6hhJb2z7WE3reBI3WjC0ZenZgwfC0FqMWTtHwM
 vX2aa0NrH7nmOaSEc891YhkjdLmwmDJG0huy6HNzALSqnJKqR0jWaxeb++rZDdkCTjcbEMOJT
 mvKIj9CYssIgjj9lt+arr9j/Z90aypMSs6j7sw2wI+wxQsTCfCBU//Za3cDHYWnPQsYSAef4W
 2AYOfbo45Xf04ItXZ+H2oiZLKxkDeoml65+xppiJhwIjjRKqvhpSBOd1/hI3vOkbajOvB2p/q
 SX9S+jZmjWm4ci+F/bH2c3Od8/ouovzhYxcPVg7T7PMRkI9QE/Hwl+5WJ4St36gaq5tKszB0r
 BKoRP2vPHsQIo+SGUX//jBGBw3hGB7rkwq5938zjA1WZvRUY9mPNh+F2I6PCoGqsDCBNyBgeR
 cyCJzdBsMYzNi+6+aY2G+Mx7qHa0UrWxhSNTvhHJg5vFApbfOY41KldGLTVx3fcugG0tsqA1f
 U3PGU4CAusCr+5upILINnHschBWHhUFTFQYSwysB8DDmseBB+31FDwMlwQsqix5tNFIuqesOm
 Va0CS6AuXAl5VoRcc0UJvn5j2/AekEJ+0RZLQ+EgBBYasYXJtELCqytEapjnxVO4TiyF+bEWx
 +rF+wA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.2-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

