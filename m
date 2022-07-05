Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC602566494
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 10:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiGEHr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 03:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiGEHrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 03:47:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ADC13D71;
        Tue,  5 Jul 2022 00:47:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso1464379pjj.5;
        Tue, 05 Jul 2022 00:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rVfQWJaIQy/In2wBEW2mJJ8z3LRK3QoqQlDB/xYBsN4=;
        b=gn4eRcS7V35rzfDq02Cg2y9jtimd08xeNcAVPuWQ+eL7NnVI2OOY6WIx/BoaVQD4d+
         G0/qTv6JYBw84wmV46p+/sK1nbJAC7sA/2Z0ixPu0AVgD4oLdgagPSbJh5HodQLtl2rB
         M9jZYUVYPCxUm9MwH6i98IyVVWJnRVSak/IyiNkA/b7O0hxOjjnDkf9tvTxzVZyDCmbm
         9B83Y9HKH0Xhx1YqUBq8JeRLYNegGcElThe+oaWVPFtlisziw3niq1eDeF7cWVbOxLMQ
         d0Nyc5i1wNhAnfAzD7rK97mVQSzcoq2ZPN7j9FPiwx11cgZqK2zJM+7OdU03dLE7vwx8
         GzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rVfQWJaIQy/In2wBEW2mJJ8z3LRK3QoqQlDB/xYBsN4=;
        b=5+WuZixJiT3clDyPWcdnvvV09V00T1nEwqL2eYok8BTAMnIqgXP/oNlb6c7xysCCXO
         zCRfCVikb25+V2piztVuaf+PaskKPvGqlrtUPXxe+zem2XSdvSOmTXDTt4ApeLhQC64T
         FFBjt3g5IFGsnh9JGIWS38J0BMCpvxu88asbIBU6FzXohW2g0TzEfbIbLjj54XFHCAom
         uBAWO1EDJyPvc9zxX+54UkeDOUmboeppbAO3v5lSJSsaohh4m30aoAPR4t+2A+Mde3hv
         tefG5VeTqBBg/Iqp5ROHZEGbNKMnT6oPsT4kvLvzI18NdJ+QEPiDC8r+hnuoL0V7x8Gb
         ALRA==
X-Gm-Message-State: AJIora8kbfPwi/FIkf7YkqDjhQT55eursxASaSH7p/Z0F458FR5mgBnT
        lU/MU3AUr1kqQyG8g+3YxY4OsDrxNKw=
X-Google-Smtp-Source: AGRyM1tz4nq+HThPF+SdxAaxp5hFlo3JVLlTmTOkJFPA4U/z1++LLg+iZ23uqxe/TYlsl59IRUMZDw==
X-Received: by 2002:a17:902:8f89:b0:168:d336:ddba with SMTP id z9-20020a1709028f8900b00168d336ddbamr38757829plo.1.1657007240452;
        Tue, 05 Jul 2022 00:47:20 -0700 (PDT)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f4-20020a655504000000b0040de29f847asm17007894pgr.52.2022.07.05.00.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 00:47:20 -0700 (PDT)
Message-ID: <62c3ec88.1c69fb81.b5648.7f2b@mx.google.com>
X-Google-Original-Message-ID: <20220705074718.GA1276177@cgel.zte@gmail.com>
Date:   Tue, 5 Jul 2022 07:47:18 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
        "linux-ntfs-dev@lists.sourceforge.net" 
        <linux-ntfs-dev@lists.sourceforge.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>,
        "syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com" 
        <syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com>,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Subject: Re: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
 <20220623094956.977053-1-xu.xin16@zte.com.cn>
 <YrSeAGmk4GZndtdn@sol.localdomain>
 <CAKYAXd8qoLKbWGX7omYUfarSugRnose8X8o3Zhb1XctiUtamQg@mail.gmail.com>
 <7FBC6FD2-5D60-4EB8-96D5-A6014D271950@tuxera.com>
 <CAKYAXd-cg5rvXo-MYZ29+wiE3BYbg4vqDHrOHtu77ox-+7dPBw@mail.gmail.com>
 <790E333B-FFA5-4C8E-95D3-BCBA7679F9C4@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <790E333B-FFA5-4C8E-95D3-BCBA7679F9C4@tuxera.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 24, 2022 at 03:26:27PM +0000, Anton Altaparmakov wrote:
> Hi,
>=20
> > On 24 Jun 2022, at 15:37, Namjae Jeon <linkinjeon@kernel.org> wrote:
> > 2022-06-24 21:19 GMT+09:00, Anton Altaparmakov <anton@tuxera.com>:
> >> Hi,
> >>=20
> >> On 24 Jun 2022, at 03:33, Namjae Jeon
> >> <linkinjeon@kernel.org<mailto:linkinjeon@kernel.org>> wrote:
> >>=20
> >> 2022-06-24 2:08 GMT+09:00, Eric Biggers
> >> <ebiggers@kernel.org<mailto:ebiggers@kernel.org>>:
> >> On Thu, Jun 23, 2022 at 09:49:56AM +0000,
> >> cgel.zte@gmail.com<mailto:cgel.zte@gmail.com> wrote:
> >> From: xu xin <xu.xin16@zte.com.cn<mailto:xu.xin16@zte.com.cn>>
> >>=20
> >> As the bug description at
> >> https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.=
cn/
> >> attckers can use this bug to crash the system.
> >>=20
> >>=20
>=20
> >> The correct solution is to use IS_ERR_OR_NULL() in places where an emp=
ty
> >> attribute is not acceptable. Such a case is for example when mounting =
the
> >> $MFT::$DATA::unnamed attribute cannot be empty which should then be
> >> addressed inside in fs/ntfs/inode.c::ntfs_read_inode_mount(). There ma=
y be
> >> more call sites to ntfs_mapping_pairs_decompress() which require simil=
ar
> >> treatment. Need to go through the code to see...
> > I think that it is needed everywhere that calls it. Am I missing someth=
ing ?
>=20
> It is not needed everywhere.  It is only needed in code paths that requir=
e there be a runlist afterwards because the code paths assume there must be=
 one.  So for example for $MFT it by definition cannot have an empty runlis=
t as we are already reading from the $MFT so it has an allocation so the ru=
nlist cannot be empty.  But the fuzzed image that is showing the problem th=
at you are trying to fix has such a corrupt volume that the runlist is in f=
act empty - note it is NOT corrupt but it is valid but empty.  This then le=
ads to the problem that we try to load the runlist for the $MFT and we do n=
ot check whether the result is empty because we assume it cannot be empty. =
 Clearly when you have a corrupted image that assumption can be wrong so we=
 need to check for both error and for it being empty, hence IS_ERR_OR_NULL(=
).  But if we are accessing an attribute elsewhere in the driver and that h=
appens to be empty then we want a NULL runlist to be obtained so we can the=
n operate with the attribute.  We do not want attempting to map the runlist=
 to fail.  The code can try to map the runlist for all non-resident attribu=
tes before working with them and if the attribute is zero length then the r=
unlist is NULL until we write something to the attribute at which point it =
becomes non-NULL describing the allocated clusters.


So to fix the current bug, how about this patch?

--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -183,7 +183,14 @@ static int ntfs_read_block(struct page *page)
     vol =3D ni->vol;
     =20
           /* $MFT/$DATA must have its complete runlist in memory at all
	    * times. */
	    -    BUG_ON(!ni->runlist.rl && !ni->mft_no &&
		 !NInoAttr(ni));
		 +    if (IS_ERR_OR_NULL(ni->runlist.rl) && !ni->mft_no
		 && !NInoAttr(ni)) {
		 +        ntfs_error(vol->sb, "Runlist of $MFT/$DATA is not cached. "
		 +                    "$MFT is corrupt.");
		 +        unlock_page(page);
		 +        if (IS_ERR(ni->runlist.rl))
		 +            return PTR_ERR(ni->runlist.rl);
		 +        return -EFAULT;
		 +    }
--

Thanks
xu xin

>=20
> Your patch violates the design of the code which is that empty attribute =
inodes have a NULL runlist and your patch will cause perfectly good attribu=
tes to be rejected if their runlist is attempted to be mapped when they are=
 empty.  You would then have to start checking everywhere in the code wheth=
er an attribute has zero allocated_size (or compressed_size if compressed a=
nd/or sparse) and if so you would need to then not attempt to map the runli=
st which would be ugly.  Much better to have the code path streamline so it=
 just returns an empty runlist...
>=20
> It may be possible that the current OSS ntfs driver can indeed function w=
ith your patch but it still violates how the code is designed to work which=
 is why I am not happy to take your patch.
>=20
> > I can not understand why the below code is needed in
> > ntfs_mapping_pairs_decompress().
> >=20
> > /* If the mapping pairs array is valid but empty, nothing to do. */
> > if (!vcn && !*buf) {
> > return old_rl;
> > }
> >=20
> >> +++ b/fs/ntfs/runlist.c
> >> @@ -766,8 +766,11 @@ runlist_element
> >> *ntfs_mapping_pairs_decompress(const ntfs_volume *vol,
> >> return ERR_PTR(-EIO);
> >> }
> >> /* If the mapping pairs array is valid but empty, nothing to do. */
> >> - if (!vcn && !*buf)
> >> + if (!vcn && !*buf) {
> >> + if (!old_rl)
> >> + return ERR_PTR(-EIO);
> >> return old_rl;
> >> + }
> >> /* Current position in runlist array. */
> >> rlpos =3D 0;
> >> /* Allocate first page and set current runlist size to one page. */
> >>=20
> >>=20
> >> - Eric
